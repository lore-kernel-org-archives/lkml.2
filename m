Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab1E1CZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 22:25:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51792 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab1E1CZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 22:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=gM0gV1oN3hzbNqpPrGvYbZrNVWECf2H6jArec/uEiPZ87XP5JDVn00pMnSOlDl4bt2
         Pexa3eHX7hSMofAZkMO7r4NDxZEUSFoiXn7Da3ECgthZFt1ZVycZUPNSQN57pCQgnYp6
         thwEAYuw9oC3q+xtzizEZRdlRsW6ki+vgWn1M=
MIME-Version: 1.0
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Sat, 28 May 2011 10:24:39 +0800
X-Google-Sender-Auth: MfE9q_J4zZvyo3pjGh3CLbiFOHc
Message-ID: <BANLkTin+3RZVh3oEQA6jbHt=YFZZ9s3M5A@mail.gmail.com>
Subject: fsblock status?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

I was reading lwn introductions of fsblock recently. Although the
latest discussion happened two years ago, it seems it is not merged
yet. So I'm wondering what is the status of this work. Is it still
under development/testing, or is it dropped in favor of something
else?

-- 
Thanks,
-Bergwolf
