Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0I3ApR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:45:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0I3ApQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=WQpOTjJbOthVqcIEvTerssQLONL/6m/4CIuWu50nn2GAx7FbLbn5VqWV9h29VqatpU
         9jbvzLv/Q9o/fBGjrtHVDAp2Et07omuZHKCQXBLHwDoU4qHnpWPLucK9FSW2SUN/cJo6
         tFYE96n05i8u6/4iiHIkGfii/ugSE/Mdu8BCI=
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 09:45:14 +0900
X-Google-Sender-Auth: 6BKlP8RKqSJWUf2XnDcDOCmGRjE
Message-ID: <AANLkTi=NFz95jvk73cgXGV-kzj7FFazgMJ6D+GOXr3Kb@mail.gmail.com>
Subject: Please don't edit the subject. Use S5PC110 & S5PC210 as is
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Fujak <t.fujak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please don't edit the subject.

http://git.kernel.org/?p=linux/kernel/git/kgene/linux-samsung.git;a=commitdiff;h=d8c3d96f5df54251c06686bb00811e4b7e0f6547
http://git.kernel.org/?p=linux/kernel/git/kgene/linux-samsung.git;a=commitdiff;h=7dcde8f18b0df4d332d6b359fd6270772a42f71f

Patches from DMC we decide to use the S5PC110 & S5PC210 as we're only
received the Spec C110 & C210.
Most of people including mobile division don't know the V210 & V310
SOC receptively.

We're already confusing with names, we always talk with C110 & C210
but works on V210 & V310 directory.

well question. What's the SOC is used at Galaxy S & wave phone?

I think S5PC110 is more well known than S5PV210.

http://lwn.net/Articles/399720/
The conclusion of the 2.6.36 merge window
Systems and processors: Income s.r.o. PXA270 single-board computers,
Wiliboard WBD-111 boards, and Samsung S5PC210-based systems.

Thank you,
Kyungmin Park
