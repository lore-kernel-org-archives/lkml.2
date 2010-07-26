Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0GZU2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:28:33 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49558 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0GZU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=om4saOtENo+3wsptRWI8AGjrIX1Xi5YiML4OuOuORMLkbHz/WcsKfwkx90ejlPMxk/
         8SsOWG8+0nR332mfkvgvceX8R2XbACrn2p7r9wPnKDBLlqHSlBSQK3wKtwylMY2cJZCD
         FqcHE3QRyeCyfAN0xgcCw4Qgf933nn8/fGHVQ=
MIME-Version: 1.0
Date: Mon, 26 Jul 2010 13:28:28 -0700
Message-ID: <AANLkTi=zMuMaRtM8R7TLC8Y82aN7Fbc__E=NOK6_6TzH@mail.gmail.com>
Subject: Perle SX card support
From: "Paul G. Allen" <pgallen@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running CentOS 5.5 with kernel 2.6.18-194-EL-PAE-i686. I have a
Perle SX card in the box that works on the same box in Windows XP
(though the serial ports randomly stop working on occasion, which
seems to happen no matter what serial IO device I use in XP), but it
will not work in Linux. I see that the driver is supposedly included
in the kernel, but we can't seem to get it to work.

Will this card work at all with kernel 2.6.18-194 or 2.6.18-194.8.1?
If so, what do we need to do to get it working?

TIA,

PGA
-- 
Paul G. Allen, BSIT/SE
Owner, Sr. Engineer
Random Logic Consulting
www.randomlogic.net
