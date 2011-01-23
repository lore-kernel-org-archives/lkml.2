Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1AWRDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:03:53 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:33661 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751054Ab1AWRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:03:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJvtO01Ld/sX/2dsb2JhbAAMhAfOZI8zgSSDOHQEhHA
X-IronPort-AV: E=Sophos;i="4.60,366,1291611600"; 
   d="scan'208";a="88975093"
Message-ID: <4D3C5F73.2050408@teksavvy.com>
Date: Sun, 23 Jan 2011 12:03:47 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
no longer work.  And if I grab newer/patched versions of those from the latest
Ubuntu 10.10, then those newer/patched versions do not work with kernels
*before* 2.6.36.

At first glance, this looks like a visible regression.
Is there a version of input-utils that works with both
old and new kernels ?

Thanks
