Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2EGLBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:01:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61712 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2EGLBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:01:14 -0400
MIME-Version: 1.0
Date: Mon, 7 May 2012 19:01:13 +0800
Message-ID: <CABgQ-TjBj3oPT6r0PVCxEfhVzYxCVoyjdG3=4DDHB5k9=NrP7A@mail.gmail.com>
Subject: HELP: I don't understand why buid composite gadgets code into one file
From: Changbin Du <changbin.du@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb gadget code "zero.c" writes:
/*
* Kbuild is not very cooperative with respect to linking separately
* compiled library objects into one module. So for now we won't use
* separate compilation ... ensuring init/exit sections work to shrink
* the runtime footprint, and giving us at least some parts of what
* a "gcc --combine ... part1.c part2.c part3.c ... " build would.
*/
#include "composite.c"
#include "usbstring.c"
#include "config.c"
#include "epautoconf.c"

#include "f_sourcesink.c"
#include "f_loopback.c"
------------------------------------------------------------------
I don't understand the meaning of "ensuring init/exit sections work to
shrink the runtime footprint" . Can anyone help me? thanks!
