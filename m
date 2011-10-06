Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab1JFWAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:00:19 -0400
Received: from nm21-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.209]:38655 "HELO
	nm21-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751411Ab1JFWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:00:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 250395.47302.bm@omp1033.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=tZybd4z6QcXT1mb99rEzA1nzNtxrSlIrT8gncw/fCk3vRemzvkN5XxkStg339IhB7Ud6N6i0UlP17Ey6NaOvgjFvbPIZkQeljWAFyxkZKxLU2KrMFQKMlXynH+kXwX8NrOmDV7kELcaH/mZN7yn8mSeElyILvrRlST7ENvM3ETk=;
X-YMail-OSG: xh.P.tAVM1lBiWHKCoTO3pptUaJJ2LvAtZUz4ZqXfofMyfm
 1lgStiWufrEhen1namx5FJCvqPxtNs3qj_sYCoQDn6Sxgs8kczx9mbsinv2M
 F6vMPmIr3RdOOJnrrs3ErMB2F3eCN5cBqmHtLgkcNxAyffcKaoHKSZZ238MN
 dmJF_8irjf6kz7Vyds065iFotSe0hPNJ9_XzFuA39N1yS6zQaH0SxGfS.wdF
 sPBXrBTwgt0.ZvgK8LIksXYplO5ohqhlRdXtc5KY6IyoY9rgF5lblwhF3EHL
 mlDNtIeMZd0IBbaVcYegSf8B8tDtfBZ6XXMdqhymLNaQbP2FOyb0sYtBjWr5
 yefsEy89MG7srrNR.4PnAerobhOXTCFaSMWexT8w.jr8aD_qUHjjF8eBX0ET
 sXChqJYVHVwx60jd9t.MJkzj.2YBodtFTaPYx7VUEr0fSCf9BVRWIpoDQ3sA
 JEA8Hvm.Z1LAIt6CLq42NsbE-
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com> <yun1uuslfhg.fsf@aiko.keithp.com> <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com> <yun4nznmbxk.fsf@aiko.keithp.com> <1317849643.25371.YahooMailNeo@web130122.mail.mud.yahoo.com> <yuny5wzktcs.fsf@aiko.keithp.com>
Message-ID: <1317938416.26506.YahooMailNeo@web130123.mail.mud.yahoo.com>
Date: Thu, 6 Oct 2011 15:00:16 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
To: Keith Packard <keithp@keithp.com>,
        "terraluna977@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <yuny5wzktcs.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I now see that the patch I submitted, while against the native backlight related code, is not against the patch-related code.
I agree that this patch is not suitable for inclusion. 

