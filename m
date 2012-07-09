Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2GIPTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:19:00 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:35911 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755025Ab2GIPS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:18:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JDAqHwMVM1nvr.tmefhqEY5Z_8GbzwHt7.IhBkNlNxA8IPK
 V0GPHs4au7x7STJ9WXSAh7KA2Sad1EAuAef_yj6ayM2ra2dCnO08bEHCTZQE
 SAA.KTQHyW.WVm26hPXOHHbxDphuU7A9eTGbcp_23qNB_4y0_iGf5pA.c.u.
 a4eTtncGvMvqTKFsPXL_DqEmcOJgagvR2CPumVQVspyIo4o1E0JoTWg_ZwHD
 t95za6lem0eaIzrVm19gnPp8euPFOoiX.6sUcLh2RfzTltU96mCkkbj.SrCk
 qI7PGzYwbis1RqOIzJiEVTO_NL7Z9OSfdnjcnvFDnAKDUS_CbeuPnWzubrdv
 sNs4E1HlNeeQ2oZFIAAPkuElrE6pMNS9pDROMT4wu7Mo1SHv8ELe1Xs7QHQ2
 .RycZMhPcRLJPdmnYCgqSQgL_hEzUnZkTR8xI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 9 Jul 2012 10:18:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        wency@cn.fujitsu.com
Subject: Re: [RFC PATCH v3 0/13] memory-hotplug : hot-remove physical
 memory
In-Reply-To: <4FFAB0A2.8070304@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1207091015570.30060@router.home>
References: <4FFAB0A2.8070304@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Jul 2012, Yasuaki Ishimatsu wrote:

> Even if you apply these patches, you cannot remove the physical memory
> completely since these patches are still under development. I want you to
> cooperate to improve the physical memory hot-remove. So please review these
> patches and give your comment/idea.

Could you at least give a method on how you want to do physical memory
removal? You would have to remove all objects from the range you want to
physically remove. That is only possible under special circumstances and
with a limited set of objects. Even if you exclusively use ZONE_MOVEABLE
you still may get cases where pages are pinned for a long time.

I am not sure that these patches are useful unless we know where you are
going with this. If we end up with a situation where we still cannot
remove physical memory then this patchset is not helpful.


