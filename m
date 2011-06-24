Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1FXNpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:45:06 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:50737 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1FXNpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:45:03 -0400
Message-ID: <4E0494E5.9040005@free-electrons.com>
Date: Fri, 24 Jun 2011 15:45:09 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: david.wagner@free-electrons.com
CC: linux-mtd@lists.infradead.org, dedekind1@gmail.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: [Addendum][RFC] ubiblk: read-only block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
In-Reply-To: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 03:34 PM, david.wagner@free-electrons.com wrote:

>  drivers/mtd/ubi/Kconfig  |    9 +
>  drivers/mtd/ubi/Makefile |    1 +
>  drivers/mtd/ubi/ubiblk.c |  462 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 472 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mtd/ubi/ubiblk.c

The patch was made against tag v2.6.39

The Kconfig description states that the module caches the reads from UBI
volume ; it isn't true.
-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
