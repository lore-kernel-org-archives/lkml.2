Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab0KOChx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:37:53 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40599 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0KOChw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:37:52 -0500
Date: Mon, 15 Nov 2010 11:31:55 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC PATCH] Make swap accounting default behavior configurable
 v2
Message-Id: <20101115113155.83361d21.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101115020330.GB9882@balbir.in.ibm.com>
References: <20101110125154.GC5867@tiehlicka.suse.cz>
	<20101111094613.eab2ec0b.nishimura@mxp.nes.nec.co.jp>
	<20101111093155.GA20630@tiehlicka.suse.cz>
	<20101112094118.b02b669f.nishimura@mxp.nes.nec.co.jp>
	<20101112083103.GB7285@tiehlicka.suse.cz>
	<20101115101335.8880fd87.nishimura@mxp.nes.nec.co.jp>
	<20101115020330.GB9882@balbir.in.ibm.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 07:33:30 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-11-15 10:13:35]:
> 
> Thanks Nishimura-San
> 
> It seems like the motivation for the patch is to allow distros to
> enable memory cgroups and swap control, but to have swap control
> turned off by default (because we provide default on today)
>  - is my understanding correct?
> 
I think you're right.

This patch make the default behavior configurable by .config and let users
turn swap control on even if it's disabled by .config.
It will give distros and users wider choice.

Thanks,
Daisuke Nishimura.
