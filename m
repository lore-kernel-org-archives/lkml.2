Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2KRBeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:34:22 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:56808 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2KRBeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:34:21 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 23:34:19 -0200
Message-ID: <CACnwZYdSW5=MLBrOC_cD7b3AB_PcQeyjR=JPJnfPCzJapZbGEw@mail.gmail.com>
Subject: =?UTF-8?B?ZHJpdmVycy91c2IvdXNiLXNrZWxldG9uLmM6MTE3OjM6IGVycm9yOiBsYWJlbCDigJhvdQ==?=
	=?UTF-8?B?dF9lcnLigJkgdXNlZCBidXQgbm90IGRlZmluZQ==?=
From: Thiago Farina <tfransosi@gmail.com>
To: linux list <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, tom.leiming@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When compiling this source file with the following command line I get
this error:

$ make drivers/usb/usb-skeleton.o
drivers/usb/usb-skeleton.c: In function ‘skel_open’:
drivers/usb/usb-skeleton.c:117:3: error: label ‘out_err’ used but not defined
make[1]: *** [drivers/usb/usb-skeleton.o] Error 1
make: *** [drivers/usb/usb-skeleton.o] Error 2

Is this intentional? If not, what would be the right fix?

Thank you,
