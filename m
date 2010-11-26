Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0KZIJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:09:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797Ab0KZIJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:09:30 -0500
Date: Fri, 26 Nov 2010 00:09:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Brice Goglin <Brice.Goglin@inria.fr>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach v2 (resend)
Message-Id: <20101126000903.df846d3e.akpm@linux-foundation.org>
In-Reply-To: <20101126080624.GA26764@elte.hu>
References: <20101122122847.3585b447@lilo>
	<20101122130527.c13c99d3.akpm@linux-foundation.org>
	<20101126080624.GA26764@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010 09:06:24 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 22 Nov 2010 12:28:47 +1030
> > Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> > 
> > > Resending just in case the previous mail was missed rather than ignored :-)
> > > I'd appreciate any comments....
> > 
> > Fear, uncertainty, doubt and resistance!
> > 
> > We have a bit of a track record of adding cool-looking syscalls and
> > then regretting it a few years later.  Few people use them, and maybe
> > they weren't so cool after all, and we have to maintain them for ever. 
> 
> They are often cut off at the libc level and never get into apps.
> 
> If we had tools/libc/ (mapped by the kernel automagically via the vDSO), where 
> people could add new syscall usage to actual, existing, real-life libc functions, 
> where the improvements could thus propagate into thousands of apps immediately, 
> without requiring any rebuild of apps or even any touching of the user-space 
> installation, we'd probably have _much_ more lively development in this area.
> 
> Right now it's slow and painful, and few new syscalls can break through the brick 
> wall of implementation latency, app adoption disinterest due to backwards 
> compatibility limitations and the resulting inevitable lack of testing and lack of 
> tangible utility.

Can't people use libc's syscall(2)?
