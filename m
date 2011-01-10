Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1AJX2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:28:36 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16795 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJX2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:28:35 -0500
Date: Tue, 11 Jan 2011 00:28:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Valery Khamenya <khamenya@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel support for Single System Image (SSI) clustering
In-Reply-To: <AANLkTimu_F=+AetL1NDdbVGav0Fsd8xnAZ6whsBEPVXZ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1101110024330.32164@swampdragon.chaosbits.net>
References: <AANLkTimK5bBgfnRKQ8AR42aCdjVh0puLTB4g6L4oqBP_@mail.gmail.com> <AANLkTimu_F=+AetL1NDdbVGav0Fsd8xnAZ6whsBEPVXZ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1776224744-1294702114=:32164"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1776224744-1294702114=:32164
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 10 Jan 2011, Valery Khamenya wrote:

> Hi gurus,
> 
> QUESTIONS:
> 
>   Q1. is it possible to make Linux kernels more friendly to SSI-clustering ?
> 
>   Q2. is there any support for SSI-clustering planned for next kernels?
> 
> 
> DETAILS:
> 
> During 2005-2006 I've been using OpenSSI cluster based on patched
> Linux kernel and was very, very happy. With almost no efforts I was
> able to compute things overnight using OpenSSI that otherwise
> would take days.
> 
> Five years ago I've been expecting that one day Linux dev community
> will adopt the most interesting parts from OpenSSI and/or Kerrighed.

If noone involved in those projects push the changes towards mainline 
nothing will happen. The mainline kernel does not magically absorb changes 
made elsewhere.

If the changes those projects make are generally useful to mainline and 
are mature and stable, then perhaps someone involved in those projects (or 
an interested bystander - like yourself) should perhaps consider 
submitting some of those patches to LKML and/or relevant maintainers.
Noone is going to do the work for you - you have to push those 
modifications if you believe they are worth it.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1776224744-1294702114=:32164--
