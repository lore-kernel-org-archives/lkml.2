Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1KLXuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 18:50:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52811 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1KLXuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 18:50:07 -0500
MIME-Version: 1.0
In-Reply-To: <201111122325.09134.rjw@sisk.pl>
References: <201111120341.12473.arnd@arndb.de> <201111122325.09134.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 12 Nov 2011 21:49:45 -0200
X-Google-Sender-Auth: c9GM89bbyJHOz0KiYhunmdAOp3I
Message-ID: <CA+55aFyW=8SJ-a8c63Pjijad+HY6y_xaB_JoT4diZufMRT=o+w@mail.gmail.com>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 8:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Thanks for the info.  Unfortunately, I've already resent the patch without
> your Tested-by: tag, but it can still be added when the patch is committed.

Added, committed, and pushed out,

              Linus
