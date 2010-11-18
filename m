Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab0KRR5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:57:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab0KRR5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:57:11 -0500
Date: Thu, 18 Nov 2010 09:52:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Make swap accounting default behavior configurable v4
Message-Id: <20101118095247.2445b092.akpm@linux-foundation.org>
In-Reply-To: <20101118102349.GF15928@tiehlicka.suse.cz>
References: <20101116101726.GA21296@tiehlicka.suse.cz>
	<20101116124615.978ed940.akpm@linux-foundation.org>
	<20101117092339.1b7c2d6d.nishimura@mxp.nes.nec.co.jp>
	<20101116171225.274019cf.akpm@linux-foundation.org>
	<20101117122801.e9850acf.nishimura@mxp.nes.nec.co.jp>
	<20101118082332.GB15928@tiehlicka.suse.cz>
	<20101118174654.8fa69aca.nishimura@mxp.nes.nec.co.jp>
	<20101118175334.be00c8f2.kamezawa.hiroyu@jp.fujitsu.com>
	<20101118095607.GD15928@tiehlicka.suse.cz>
	<20101118191427.fd86db5c.nishimura@mxp.nes.nec.co.jp>
	<20101118102349.GF15928@tiehlicka.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 11:23:49 +0100 Michal Hocko <mhocko@suse.cz> wrote:

> > I'm sorry again and again, but I think removing "noswapaccount" completely
> > would be better, as Andrew said first:
> 
> I read the above Andrew's statement that we really should stick with the
> old parameter.

yup.  We shouldn't remove the existing parameter, which people might be
using already.

> > > So we have swapaccount and noswapaccount.  Ho hum, "swapaccount=[1|0]"
> > > would have been better.

What I meant was that it was a mistake to add the "noswapaccount" in
the first place.  We should have made it "swapaccount=0", because that
would leave open the later option of reversing the default, and
enabling "swapaccount=1".

It also give us the option of adding "swapaccount=2"!  Perhaps to
enable alternative swap accounting behaviour.
