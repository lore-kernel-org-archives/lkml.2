Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1HEOgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:36:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60837 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab1HEOgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E3BEABC.3030909@landley.net>
References: <4E3BEABC.3030909@landley.net>
Date: Fri, 5 Aug 2011 10:36:07 -0400
Message-ID: <CACqU3MUExSQEFAz415p8byAo=CLtfbmVVy98iCbMx_wGC3ppuA@mail.gmail.com>
Subject: Re: Where did Linus' git tree go?
From: Arnaud Lacombe <lacombar@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 9:06 AM, Rob Landley <rob@landley.net> wrote:
> I did a pull and it said the remote hung up unexpectedly.  About the
> fifth time I went to git.kernel.org and searched for "torvalds" and
> there's no 2.6 tree...  Checked the list but I don't see a post from
> Linus about it...
>
> Tree moved?  Transient glitch?  Nothing on lwn.net about it...
>
you missed a message. He pointed out on a "Note on Linux 3.0 and the
3.1 merge window" that the tree had moved from

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary

to

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=summary

but that the first one would be kept to maintain existing remote working.

Search for

Message-ID: <CA+55aFxKbAXXv2x0ykezsXbSeZZQ0DwPRzYPY_QZ0NdFKes_NQ@mail.gmail.com>

to get the message original.

Now you or kernel.org may have had connectivity issues :)

 - Arnaud

> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
