Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab1FWSnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:43:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61632 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab1FWSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iSTwwaMKKGhkAdAOtdMkTYM4sgFHgZSaTPLU1d6Dp9eIEoS9dUGUYfaqzlL6wiHEPF
         fYJ7YY6vBKzzyW2k1X+PDk1knQG1YZjQgcgUUBDO+MNOX/4z5V4eo42NE7WXOPRa895u
         VAQ2YsgOn+2ArPwLUpvfHgeN8a8JqF5Otd+Is=
MIME-Version: 1.0
Date: Thu, 23 Jun 2011 20:43:14 +0200
Message-ID: <BANLkTim1=iKJTpcagPi+ZoomvBWgPeG63Q@mail.gmail.com>
Subject: Reading MtRainier CD in plain CD unit?
From: =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(please CC me on answers)

During cleanup I found a MtRainier (MRW) formatted CD-RW with an UDF
1.02 filesystem on it.

I tried to read it in aplin CD-ROM unit that has no special MRW
support with a recent kernel (Ubuntu 11.04 distro) but it does not
work. It sees only a dummy iso9660 volume that has a few readme files
informing that special software is needed to read them (It suggests
Nero EasyWrite or InCD, for Windows, as it was formatted with a Nero
utility).

As I remember from back then, this helper code is patent encumbered
and that's why Linux does not have it.
Has there been any change about this lately?

Regards,
David
