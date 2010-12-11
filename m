Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab0LKFxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 00:53:18 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34866 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0LKFxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 00:53:17 -0500
Date: Sat, 11 Dec 2010 00:53:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: HarryWei <harryxiyou@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: CodingStyle Problem
In-Reply-To: <20101211053601.GA8683@gmail.com>
Message-ID: <alpine.DEB.2.00.1012110050060.5069@localhost6.localdomain6>
References: <20101211053601.GA8683@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Dec 2010, HarryWei wrote:

> Hi all,
>       I just read the CodingSyle at Documentation directory in linux-2.6.23 kernel source code.
>       But a problem happened to me like following.
>       Functions in linux-2.6.23/fs/fs-writeback.c are "static int" and function name are in different lines.(function name in following line)
>       I can't find the rule in CodingStyle. That We often program functions are "static int" and function name are in the same line.
>       When do we do the first or second way? What is different between them?
>
>   Any answer is okay.
>   Best regards.

  the advantage to the form

static int
function-name

is that, if you're looking for the actual function *definition* in the
file, having the function name at the start of a new line means you
can search for it with the pattern "^function-name" so that you don't
have to wade through all of the invocations of that function.

  i like that style; others claim that with proper cross-referencers
like cscope, doing that is redundant.  as far as i know, the kernel
coding style doesn't take a position on that, but i'm willing to be
corrected.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
