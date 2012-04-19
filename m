Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab2DSOe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:34:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58285 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab2DSOe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:34:26 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 19 Apr 2012 11:34:05 -0300
Message-ID: <CAMOw1v6Q6_6g-4UKvixDLNkRvv0C_LdkHjYJynQUhJ6_sraf6A@mail.gmail.com>
Subject: kmod 8
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmod 8 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-8.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-8.tar.sign

Very small, bug-fix release, nothing new. Last release I changed my
laptop, which caused a wrong setup and kmod 7 got out with docs
disabled. kmod 8 fixes as well.

Check NEWS file for more information.

Shortlog is below.


Lucas De Marchi

--

Dave Reisner (1):
      modprobe: handle -ENOENT return from init_module

Elan Ruusamäe (1):
      modprobe: fix typo in config dump: option->options

Kay Sievers (1):
      doc: silent man page generation and fix gtk-doc warnings

Lucas De Marchi (4):
      README: note that there are more files to read
      TODO: add item to implement actions in kmod
      doc: remove links to NULL going nowhere
      kmod 8
