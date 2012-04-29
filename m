Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2D2PrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 11:47:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63902 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2D2PrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 11:47:09 -0400
Message-ID: <4F9D6277.9080402@lwfinger.net>
Date: Sun, 29 Apr 2012 10:47:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Gabriel Paubert <paubert@iram.es>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Schwab <schwab@linux-m68k.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty/serial/pmac_zilog: Fix "nobody cared" IRQ message
References: <4F9C830D.8040906@lwfinger.net> <20120429090520.GA26740@visitor2.iram.es>
In-Reply-To: <20120429090520.GA26740@visitor2.iram.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 04:05 AM, Gabriel Paubert wrote:
> On Sat, Apr 28, 2012 at 06:53:49PM -0500, Larry Finger wrote:
>
> Hmm, I'm not a native english speaker, but I have the feeling that
> it would be more grammatically correct to use "opened" instead of "open".
>
> Of course if the message never triggers, it's less of concern :-)

English is my native language, but that might not help. :)

I would say "the device has not been opened", but "it is not open". More 
generally, to me "opened" denotes past tense, and "open" is used in the present.

Even with the other bug, the message never triggered as I did not have debugging 
enabled. Given the relative rarity of PPC-based boxes running Linux, the message 
may never print.

Thanks for the comment.

Larry

