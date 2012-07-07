Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2GGVUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:20:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50817 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2GGVUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:20:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy7RncR_z9M+DRzSXJY7cWxY9zG0ioLdiefhxkH__Z7Yw@mail.gmail.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
 <20120706203825.20ce3e47@pyramind.ukuu.org.uk> <CA+55aFy7RncR_z9M+DRzSXJY7cWxY9zG0ioLdiefhxkH__Z7Yw@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 7 Jul 2012 23:19:52 +0200
Message-ID: <CAPXgP12vGkh1q4-L3+wYY5XWZURBXOWQCmovARr0cbf+dHinVQ@mail.gmail.com>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte reads
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Jukka Ollila <jiiksteri@gmail.com>,
        linux-kernel@vger.kernel.org, jbeulich@novell.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 10:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Kay, this needs to be fixed.
>
> Suggested fix: just use the 'seq_printf()' interfaces, which do the
> proper buffering, and allow any size reads of various packetized data.

I'll have a look.

> Of course, I'd also suggest that whoever was the genius who thought it
> was a good idea to read things ONE F*CKING BYTE AT A TIME with system
> calls for each byte should be retroactively aborted. Who the f*ck does
> idiotic things like that? How did they noty die as babies, considering
> that they were likely too stupid to find a tit to suck on?

Maybe the bs=1 in the dd call stands for bullshit. :)

Kay
