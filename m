Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2HRWCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:02:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51835 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2HRWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:02:34 -0400
Date: Sat, 18 Aug 2012 23:06:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Luedtke <mail@danrl.de>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, chaosman@ontika.net, muthur@gmail.com,
        kerolasa@iki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120818230651.49cef81a@pyramind.ukuu.org.uk>
In-Reply-To: <1345333117-2826-1-git-send-email-mail@danrl.de>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2012 01:38:37 +0200
Dan Luedtke <mail@danrl.de> wrote:

> This patch introduces the Lanyard Filesystem (LanyFS), a filesystem
> for highly mobile and removable storage devices.
> 
> Signed-off-by: Dan Luedtke <mail@danrl.de>
> ---
> "Release early, release often" they said. Here is my work of the
> past weeks. This is a RFC patch, so please comment, criticize, suggest
> and test test test. Of course patches are welcome, too.

Starting from first principles a bit you might want to read/review Arnd
Bergmanns work on Flash drive performance and behaviour. It has some
fairly significant impact on how you lay out your file system and in
particular questions like "where should I put stuff that is updated
regularly' (in the same blocks a FAT fs would put the FAT being one clear
answer)

http://lwn.net/Articles/428584/

and a pile of other stuff.
