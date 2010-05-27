Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab0E0FFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:05:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61502 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0E0FFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Id/dCz8O2b2nGKhuuFV5LCKGhUrw63IlJvsuvQeR+RVwLDOGfIYH42KXq89v3sY81+
         2q20OpVD/kFH/848+XvvppbK9zGymu7kUoEhd36I3BG8xK28CcWL1qfIpKwQOTxoMiju
         v5galPYihNuJSvx5tHpGg4isYv+B/ssrvMpJI=
MIME-Version: 1.0
Date: Thu, 27 May 2010 10:35:12 +0530
Message-ID: <AANLkTindNIXjAcuGKsg_xBL9jaQ96wxD54xoZe2iPD5v@mail.gmail.com>
Subject: mylinux.list@gmail.com
From: linux_newbie good <mylinux.list@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My board has a MIPS based Processor and a micro-controller.  The
communication between these two interfaces is through an I2C bus. The
Linux driver for my I2C controller (i mean the one in MIPS processor)
has support for master transmitter and master receiver whereas I could
not find support for slave TX and slave RX modes. Do I need to write
my own functions for slave support? If so, what kind of changes need
to be done, for slave mode support? Is there any other sample driver
which can help ?


Regards,
newbie
