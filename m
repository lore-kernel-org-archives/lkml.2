Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab0KOCDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:03:54 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56932 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab0KOCDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:03:53 -0500
Date: Mon, 15 Nov 2010 07:33:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Make swap accounting default behavior configurable v2
Message-ID: <20101115020330.GB9882@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101110125154.GC5867@tiehlicka.suse.cz>
 <20101111094613.eab2ec0b.nishimura@mxp.nes.nec.co.jp>
 <20101111093155.GA20630@tiehlicka.suse.cz>
 <20101112094118.b02b669f.nishimura@mxp.nes.nec.co.jp>
 <20101112083103.GB7285@tiehlicka.suse.cz>
 <20101115101335.8880fd87.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101115101335.8880fd87.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-11-15 10:13:35]:

Thanks Nishimura-San

It seems like the motivation for the patch is to allow distros to
enable memory cgroups and swap control, but to have swap control
turned off by default (because we provide default on today)
 - is my understanding correct?

-- 
	Three Cheers,
	Balbir
