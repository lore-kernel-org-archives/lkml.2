Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0E1LqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:46:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36918 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0E1LqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VEQTAec/S4Sb3J+aAg0tvpaNTGy2F3jtrcAXsm8Zdz+ogVt8XFNnCEd+KmROvWLsU3
         oTgdRGOdsq8KDLMzOWRsrNVCoYbMcPwk2mxXM2whkYX3k5l9kpGf2SQ4RKLjnDM2rJ8E
         N6sqv1D4nErSCUarPmDpO1vp9QaMqXKojr+5g=
MIME-Version: 1.0
Date: Fri, 28 May 2010 17:16:21 +0530
Message-ID: <AANLkTil0b9y0PJd4_eUS-M16Ya3yt1i7xzaOaGmA_cZ2@mail.gmail.com>
Subject: Drivers for USB,SATA and eMMC
From: Jack <mylinux.list@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mylinux.list@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a new IOH which is connected to an x86 core through PCIe. This
IOH has SATA, USB and eMMC attached to it.. Do I need to write a
controller driver (referring the IOH data sheet) for these interfaces,
or does Linux provides any std. drivers for these interfaces. I am new
to x86 stuffs.
Could anyone guide me on this.?


-Jack
