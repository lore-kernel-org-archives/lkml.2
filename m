Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CTXKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 19:10:11 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46639 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab1CTXKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 19:10:09 -0400
X-Sasl-enc: nCfYw6TwbFAnGAY93Fpc7OOzYVsczrb5+Ml8G9pjLz7M 1300662607
References: <fuopaigyaypsqveewtjx@pwmq> <4D864A82.4090104@fastmail.fm> <4D867706.5060304@suse.cz>
User-Agent: K-9 Mail for Android
In-Reply-To: <4D867706.5060304@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and 2.6.38
From: Jack Stone <jwjstone@fastmail.fm>
Date: Sun, 20 Mar 2011 23:09:56 +0000
To: Jiri Slaby <jslaby@suse.cz>
CC: Mac <kmac@poczta.fm>, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
Message-ID: <c66d706d-9bb2-441b-9742-4a7eeac0d01e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> wrote:
>FWIW it looks good to me. Note that the very same problem is in rocket.
>And moxa enables bh interrupts unconditionally before it returns. This
>might (and likely will) make the ppp locking unhappy.
>
>Could you fix that too? (If not, I will take a look at what I can do
>about that.)
>
I'll do my best to have a look but don't hold your breath.

Thanks for looking,

Jack


-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
