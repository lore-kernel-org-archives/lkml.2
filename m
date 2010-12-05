Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0LESVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 13:21:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46046 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0LESVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 13:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UuNWp6AujQL0spG5QInssQDYWWm5RA9R35z+zvb6L2+X6/T4au7zkVgHEpAlXr5LZo
         kagF19ZUFDo0/UouAgs70uulGsWMAFWONUV1nlR30f8pUJlUdHLFEVDooKR1gGrw81tz
         oqBidXDZF5guPg0p8uVs8ys80/zy1SaaiI0DE=
MIME-Version: 1.0
Date: Sun, 5 Dec 2010 19:21:46 +0100
Message-ID: <AANLkTim9JGZ3g-q6saFr5EHhuz5yAS3J0L18bteh_hPo@mail.gmail.com>
Subject: Creating linux-headers-xxx package for building external modules
From: Greg Heinrich <greg.heinrich.list@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
apologies if this has been asked before but I couldn't find the answer
in the archives.

I would like to know if there is an easy way to create a
linux-headers-xxx package out of my own kernel tree? What I'm looking
for is something similar to e.g. the Debian package
linux-headers-2.6.32-5-r4k-ip22. This does not have to be a Debian
package by the way, a simple tgz would do.

The reason I want to create that kind of package is I need to be able
to share my kernel configuration and headers so that a colleague would
then be able to build external kernel modules for my kernel image.

I tried "make headers_install_all" but it does not export the Kernel
config and Module.symvers, ...

Note that in case it makes any difference, I am working on the ARM
architecture, and I want to support CONFIG_MODVERSIONS=y.

I thank you in advance,

Regards,
Greg.
