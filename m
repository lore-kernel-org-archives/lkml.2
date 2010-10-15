Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0JOCnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 22:43:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539Ab0JOCnN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 22:43:13 -0400
MIME-Version: 1.0
In-Reply-To: <20101015023404.GA348@elte.hu>
References: <20101015023404.GA348@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Oct 2010 19:42:11 -0700
Message-ID: <AANLkTimW_JNpKQC2ukZTqYKgSkosT0cGPb92+nH4oT1n@mail.gmail.com>
Subject: Re: [PATCH .36-rc8] a.out: Fix module build failure
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 7:34 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> The recent aout fix causes a modular build failure on x86
> (allmodconfig):

Yeah, Tetsuo Handa reported the same.

I pushed out a fix - obviously pretty much the same as yours - except
that I don't think it is worth the _GPL thing (that wasn't how it
worked before, and the other binfmt-related functions are just regular
EXPORT_SYMBOL's too).

                      Linus
