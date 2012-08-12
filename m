Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab2HLKOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 06:14:15 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55873 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2HLKON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 06:14:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] fs/fat: Fix all other checkpatch issues in dir.c
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
	<1344764687-4155-7-git-send-email-cruzjbishop@gmail.com>
Date: Sun, 12 Aug 2012 19:14:08 +0900
In-Reply-To: <1344764687-4155-7-git-send-email-cruzjbishop@gmail.com> (Cruz
	Julian Bishop's message of "Sun, 12 Aug 2012 19:44:46 +1000")
Message-ID: <87boigbeof.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cruz Julian Bishop <cruzjbishop@gmail.com> writes:

> +		charlen = t->char2uni(&nc, 1, uni);
> +

Here is strange new line.

> +		if (charlen < 0) {
>  			*uni = 0x003f;	/* a question mark */
>  			charlen = 1;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
