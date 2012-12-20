Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2LTDkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 22:40:05 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:34490 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2LTDj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 22:39:59 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 22:39:59 EST
MIME-Version: 1.0
Date: Wed, 19 Dec 2012 19:32:18 -0800
Message-ID: <CAFO3HzWnbZ+=BfF35kc1c3xQ6EUuRdri5_p14YJ_Ws17u6bMWQ@mail.gmail.com>
Subject: Kernel 3.7.1 bug: include/uapi/linux/usb/ch9.h
From: User Linux <user.kernel@gmail.com>
To: "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated from kernel 3.6.10 to 3.7.1 and encountered the following when
recompiling media_build dvb drivers:

include/uapi/linux/usb/ch9.h:597:77: error: expected declaration
specifiers or '...' before '(' token
