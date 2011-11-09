Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab1KIWJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:09:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60220 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1KIWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:09:16 -0500
Message-ID: <4EBAFA03.40405@suse.cz>
Date: Wed, 09 Nov 2011 23:09:07 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/10] TTY: serial, cleanup include file
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz> <20111109215901.16f44570@bob.linux.org.uk>
In-Reply-To: <20111109215901.16f44570@bob.linux.org.uk>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 10:59 PM, Alan Cox wrote:
> We need to move the tty_buffer objects into the tty_port.

Thanks a lot for reminding me. (I remember you telling me about this at
KS.) So I suppose you prefer this to be done first... OK, I will look
into that. Leaving the rest of the serial stuff apart for the time being.

> This needs every tty of all kinds to have a tty_port even if isn't used
> for anything else.

Heh, out-of-tree driver maintainers will cry once again. It serves them
right.

thanks,
-- 
js
suse labs
