Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab1IPEJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 00:09:18 -0400
Received: from nm6-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.206]:39474 "HELO
	nm6-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750732Ab1IPEJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 00:09:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 865988.86600.bm@omp1033.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=vipuO/rZXg7CBvlGC79GARG9TGdMDXjTLJgESV3dYK0xdaPSVDr9oGcFqq/CQuVdmBkjzQuKUxD73PZW0TzzDPasoh+eeMa/Fk6+wZxsfazsGHOgvs8Oj1BZWEyp+aKiPv2nf6RO4+amwfGnx/4Ug1OMBv7ssq6t46pa7TOw3EU=;
X-YMail-OSG: lPl_fJ4VM1mcCjrARFG9i6Z1tvt5345tJe3W6OUdV.6Uy1I
 qCt4LNt0IDnSulPrEnVmKTRk.klopLhQOr5odrp8iMMuy5xWxqrWVz8x9k1m
 02sZMxEVgebB96zcAvwZo5K1c5Duq8zsO4udCgLvaTzUPKZhY6sGdLpEqX8e
 2SeI8NfwvJlwWoTsyMSe4MtTUO0cdY7VdW5dPjxfEcAXc1sP0HutGgfQ_uPr
 l_GusZYYXG84yC4t.OcsEVg.7YxMk2bMCTvQzBYabbTqrM.Kv5zgJA3UuSIJ
 __5iD.hdu9088s8bvCKKI6ikw9tQ_yCJAgy.0qio3Rh7_OGg7SklNPVv8TKW
 xX7fRf.R_sLSuWFQ2T.qpx9zLkJ_3MmSXn2lruVCcEqUoQo5X709yWQMD81j
 NEQEtUdq3MlSMI_9dr9_ArP9relI6xS3.NwtU3Yiy0AMRD_1aE2fhVmC_1PC
 F0O5.M5iR_VaCJvCFRWbky2jfkFBLu9GbEk..vPp_FpxPHk5LhLExbaNWILn
 g_6avJ377BEntA7Wji767LFrf89rTW22trCF57tIiDWppARp4vjNGfSukyOU
 FsGNGRQA-
X-Mailer: YahooMailWebService/0.8.113.315625
References: <1316099130.7561.YahooMailNeo@web114311.mail.gq1.yahoo.com> <CAF1ivSaGJX54Nn7t7JnBZV-42t9665wzt-pf_30OERAuAE2=UQ@mail.gmail.com>
Message-ID: <1316146096.85272.YahooMailNeo@web114303.mail.gq1.yahoo.com>
Date: Thu, 15 Sep 2011 21:08:16 -0700 (PDT)
From: Justin Mattock <justinmattock@yahoo.com>
Reply-To: Justin Mattock <justinmattock@yahoo.com>
Subject: Re: general protection fault: 0000 -#1] SMP
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: "refpolicy@oss.tresys.com" <refpolicy@oss1.tresys.com>,
        "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF1ivSaGJX54Nn7t7JnBZV-42t9665wzt-pf_30OERAuAE2=UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Justin Mattock <justinmattock@yahoo.com>
Cc: "refpolicy@oss.tresys.com" <refpolicy@oss.tresys.com>; "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Thursday, September 15, 2011 8:00 PM
Subject: Re: general protection fault: 0000 -#1] SMP

On Thu, Sep 15, 2011 at 11:05 PM, Justin Mattock
<justinmattock@yahoo.com> wrote:
>
>
> using the current mainline, I woke the machine up from suspend, then started to relabel the filesystem, using the stable release policy(MCS). then this showed up:
> I only have photos of the crash, due to a total system lock
> http://www.flickr.com/photos/44066293@N08/6149812345/in/photostream
> http://www.flickr.com/photos/44066293@N08/6149811913/in/photostream

Is this a regression? Does it happen for 3.0 kernel?

from looking at the archives I dont see this as a regression. last I reported somethig was in 2010
https://lkml.org/lkml/2010/7/3/155
but I could be wrong.


It crashed at __list_del_entry.
Could you enable CONFIG_DEBUG_LIST=y to get more info?

yeah this is set already in my .config. from what I remember this occured two times,
once after S2R wakeup, then on the first initial install of repolicy(tar ball stable) when .autorelabel went into play.
(but could not capture any thing due to the system doing an instant reboot.
I will keep an eye out on this. I have also update the policy to the current git(not sure if it matters or not).

Lin Ming

>
> Note: I subscribed using my yahoo accnt due to changing, but for some reason, am not able to complete the process
> (will try again to see).
>
> if you need more info let me know(I will try and recreate this, and possibly due a bisect on the kernel and/or pull refpolicy git to see)
>
> Justin P. Mattock


Justin P. Mattock

