Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab0CaKAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:00:34 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43915 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab0CaKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=R0u0LpBGao3eWHPdltGN3nXpXWk2vaZyslYblhUPZB9mVeYaSCCAlVbCFTd9LeW2wX
         Bc8J6ytwJIGpBFHSoru1vKZLQqxfB0LysQxXWxwVNwm6Ls6z7577AUIk8cxxrl679MYE
         DPHC23+/tbqTbReFzWz6FxxXNTAmgt0MhFCnw=
MIME-Version: 1.0
From: Sachin Pandhare <sachinpandhare@gmail.com>
Date: Wed, 31 Mar 2010 15:30:11 +0530
Message-ID: <n2m72cf309c1003310300k26b9aacbob7b49ff2f43f949d@mail.gmail.com>
Subject: kmemleak_scan_area
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sachin <sachinpandhare@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,
In kmemleak.c file "kmemleak_scan_area" is appearing as a structure as
well as a function.
e.g.:
- struct kmemleak_scan_area_node {
- void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)

Do you think it is a good to have it like that?

regards,
Sachin
