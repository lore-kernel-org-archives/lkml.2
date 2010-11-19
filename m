Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0KSS0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:26:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40444 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0KSS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:26:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Ffn0w6rpwsjvHz3jbuBw+vb975OYkf619ZPkD/Qa1InE7R+Ai7lFugFflggljCcL7r
         CA6fV1a8YqFuIxAPqmNkdEpd7SsrOCSKZzEAIfTj6xp2ZAoVTqOnpF8X8Y9Q/9galSdb
         aiNFAoSPvG/I9hN8crN4LuD3dQQFbMOxxe3Hw=
MIME-Version: 1.0
Date: Fri, 19 Nov 2010 19:26:13 +0100
Message-ID: <AANLkTinTwyioFt2mGmetK=rfj-q_7hLBQ_FR_aE20FXZ@mail.gmail.com>
Subject: tvp5150 extension to tvp5151
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to support fully tvp5151.
So I'm trying to understand your driver, that is ready for VBI and not
for video acquisition.
I also take sometimes a look at tvp514x.c, for instance trying to add
VIDIOC_ENUM_FMT and other ioctls.
I think we can move from tvp5150.c to tvp515x.c, maybe...
I don't think is good to have tvp51xx.c because tvp514x.c family is
more complex (more inputs...).
By now I'm using tvp5150.c with some modifications and video acquisition works.
I need to complete the support in order to have gstreamer fully running.
I'm working on 2.6.32, but I have planned to port it to mainline.
Do you have any suggestion for my work?

Thx,
Raffaele
