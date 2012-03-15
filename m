Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862Ab2COSZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:25:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54046 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760507Ab2COSZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <1331211706-9763-1-git-send-email-linus.walleij@stericsson.com>
References: <1331211706-9763-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 15 Mar 2012 19:25:14 +0100
Message-ID: <CACRpkdYfiWE=84XAD6-Ht3TsdX8bVsteyE+=WOBKhH=92D3bhg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mfd/ab8500: don't use mutex_lock_interruptible
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, are you taking these four patches or will they wait for the
next kernel cycle?

Yours,
Linus Walleij
