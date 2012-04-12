Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab2DLVRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:17:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62528 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934710Ab2DLVRr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:17:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120412183351.GQ16257@infradead.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org> <20120411180434.GH16257@infradead.org>
 <20120411180837.GJ16257@infradead.org> <20120412152256.GH24549@aftab>
 <20120412155734.GA30170@merkur.ravnborg.org> <20120412183351.GQ16257@infradead.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Thu, 12 Apr 2012 23:17:25 +0200
Message-ID: <CALxABCb6W9mqZvUoxLmThOuXJebY-q83hkrjnU3ZLAdZ5b=65Q@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@kernel.org>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 20:33, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Thu, Apr 12, 2012 at 05:57:34PM +0200, Sam Ravnborg escreveu:
>> >
>> > -QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
>> > -QUIET_SUBDIR1  =
>>
>> Who-ever came up with the names "QUIET_SUBDIR" must have had a bad day...
>
> Came from the git sources, where it still lives on:
>
> [acme@sandy git]$ git show b7774343
> commit b777434383bd2f365be6896d8c89be6c1b62a135
> Author: Alex Riesen <raa.lkml@gmail.com>
> Date:   Wed Mar 7 00:44:49 2007 +0100
>
>    Support of "make -s": do not output anything of the build itself
>
>    Signed-off-by: Junio C Hamano <junkio@cox.net>
>

Looked like a good idea at the time.

http://www.merriam-webster.com/dictionary/quiet

  qui·et
  verb \ˈkwī-ət\

  Definition of QUIET
  transitive verb
  1: to cause to be quiet : calm
