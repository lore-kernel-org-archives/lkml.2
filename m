Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1CNXfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:35:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19297 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1CNXfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:35:22 -0400
Date: Tue, 15 Mar 2011 00:35:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, greg@kroah.com, joe@perches.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
In-Reply-To: <4D7E470E.8090204@zytor.com>
Message-ID: <alpine.LNX.2.00.1103150034310.26293@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net> <20110314113254.GA2761@gmail.com> <4D7E470E.8090204@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, H. Peter Anvin wrote:

> On 03/14/2011 04:32 AM, Harry Wei wrote:
> > On Sun, Mar 13, 2011 at 11:00:09PM +0100, Jesper Juhl wrote:
> >> I believe the return type of main should always be 'int'.
> >>
> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > Acked-by: Harry Wei <harryxiyou@gmail.com>
> 
> It would make more sense to rename the function to something other than
> main().
> 
Right. That's probably a better aproach. Thanks.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

