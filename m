Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab2D0ClF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 22:41:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45077 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab2D0Ckn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 22:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120426233537.GA23799@windriver.com>
References: <20120426233537.GA23799@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 26 Apr 2012 22:40:20 -0400
Message-ID: <CAMjpGUeO4MTQtVMLAJCQ-SpTrEUOdUYGPW0YSfoAQfnshw6FHA@mail.gmail.com>
Subject: Re: [GIT pull] build fixes for less mainstream architectures
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 19:35, Paul Gortmaker wrote:
> -fix a missing include for GPIO in blackfin framebuffer.
>
> -audit and tag endif in blackfin ezkit board file, in order to find
>  and fix the misplaced endif masking a block of code.

thanks !
-mike
