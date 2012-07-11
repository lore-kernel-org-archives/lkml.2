Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab2GKPjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:39:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57672 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab2GKPjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:39:41 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: alan@lxorguk.ukuu.org.uk, "Ben Minerds" <puzzleduck@gmail.com>
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] USB: serial: Changes to conform with checkpatch.
References: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
Date: Wed, 11 Jul 2012 17:39:32 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.whagf6k23l0zgt@mpn-glaptop>
In-Reply-To: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
User-Agent: Opera Mail/12.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 16:10:14 +0200, Ben Minerds <puzzleduck@gmail.com> wrote:
> Removed various checkpatch.sh warnings and errors.

You've meant chekpatch.pl, right?

> Split patch by warning/error type.
> Corrected line wraps in emails.
>
> Signed-off-by: Ben Minerds <puzzleduck@gmail.com>

This 0/6 also confuses me -- like Greg have said the 0/n mail should not
contain any diff, just a summary -- but all the other patches look good
to me as they are only whitespace changes -- if only there was a diff
tool that understood C and compared stream of C tokens rather then a plain
text file.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
