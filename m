Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab0LCB5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 20:57:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab0LCB5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 20:57:04 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012030210200.14806@pobox.suse.cz>
References: <alpine.LNX.2.00.1012030210200.14806@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Dec 2010 17:56:16 -0800
Message-ID: <AANLkTime_NVP5RmXvgigs8U6FODv7i8vD51+J4=HwVDh@mail.gmail.com>
Subject: Re: [GIT] HID
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 5:24 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Note: you are going to get conflict in drivers/hid/hid-input.c. This is
> caused by commit a0bf0ea8 ("Input: hid-input - switch to using new keycode
> interface") which went through Dmitry's tree, as it was part of larger
> rework. It's fine to just use the variant from that commit.

Just taking Dmitry's version would have missed the removal of
KERN_DEBUG that your branch did, so I did a proper merge resolution.

Or at least it looked proper to me, and compiles. Pushed out the result,

                    Linus
