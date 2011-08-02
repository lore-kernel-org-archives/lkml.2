Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1HBJXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:23:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53468 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1HBJXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:23:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umyiotpqLv9Oz=+Mr0csdNZe=8WJvj0qW2g8fAmvSX3-_Sw@mail.gmail.com>
References: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
	<20110731173944.GA1620@ucw.cz>
	<CAC5umyiotpqLv9Oz=+Mr0csdNZe=8WJvj0qW2g8fAmvSX3-_Sw@mail.gmail.com>
Date: Tue, 2 Aug 2011 18:23:12 +0900
Message-ID: <CAC5umyjaUPTJpLcTSgRxyu+cPn7p1hAMJW_OxH9ZC3CBRc0nEA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/2 Akinobu Mita <akinobu.mita@gmail.com>:

> Aside from that, I didn't find any bugs but I still think this feature is
> useful for testing and it just add a little complexity to exiting code.
> (Maybe I need to prove it by finding more bugs)

As for the complexity, I can minimize it by moving the common functions
to lib/notifier-error-inject.c and lib/notifier-error-inject.h.
It is cleaner than adding them to kernel/notifier.c and
include/linux/notifier.h with #ifdef CONFIG_NOTIFIER_ERROR_INJECTION
as v3 patch set does.
