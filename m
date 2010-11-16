Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185Ab0KPKG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:06:57 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64158 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab0KPKGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:06:54 -0500
Date: Tue, 16 Nov 2010 19:03:09 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC PATCH] Make swap accounting default behavior configurable
 v3
Message-Id: <20101116190309.4c767874.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101116081544.GA19247@tiehlicka.suse.cz>
References: <20101110125154.GC5867@tiehlicka.suse.cz>
	<20101111094613.eab2ec0b.nishimura@mxp.nes.nec.co.jp>
	<20101111093155.GA20630@tiehlicka.suse.cz>
	<20101112094118.b02b669f.nishimura@mxp.nes.nec.co.jp>
	<20101112083103.GB7285@tiehlicka.suse.cz>
	<20101115101335.8880fd87.nishimura@mxp.nes.nec.co.jp>
	<20101115083540.GA20156@tiehlicka.suse.cz>
	<20101116134800.7d8b612d.nishimura@mxp.nes.nec.co.jp>
	<20101116081544.GA19247@tiehlicka.suse.cz>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 09:15:44 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 16-11-10 13:48:00, Daisuke Nishimura wrote:
> > Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Thank you. What should be next steps? Waiting for other ACKs or push it
> through Andrew?
I recommend you to resend the patch removing "RFC" in a clean patch format
(i.e. without any quotes).

> Btw. is this a stable tree material? I guess that distribution would
> like to have this patch and the stable is the easiest way how to deliver
> this.
> 
It's not stable material. This is not a BUG or anything that meets the conditions
described in Documentation/stable_kernel_rules.txt.


Thanks,
Daisuke Nishimura.
