Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab1JSRXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:23:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab1JSRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:23:10 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH] Input: atmel_mxt_ts - Use snprintf for sysfs attribute show method
Date: Wed, 19 Oct 2011 10:23:01 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1316115647-1244-1-git-send-email-djkurtz@chromium.org> <CAGS+omDJM700h22zsAQZRn_9qCcUk1gJsKN0GzQxG7FkK-PRsQ@mail.gmail.com>
In-Reply-To: <CAGS+omDJM700h22zsAQZRn_9qCcUk1gJsKN0GzQxG7FkK-PRsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110191023.02277.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wednesday, October 19, 2011 12:40:16 AM Daniel Kurtz wrote:
> Hi Dmitry,
> 
> I fear the following patch, and its 'Acked-by' from Nick Dyer, may
> have gotten lost:


No, it is not lost. It is commit 626af8611211c55595cd316103abd2419cd4d861 
in my 'next' branch, waiting for 3.2 merge window to open.

Thanks.

-- 
Dmitry
