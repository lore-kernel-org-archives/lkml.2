Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab1GKRzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:55:44 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39481 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab1GKRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:55:43 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Brian Marete <marete@toshnix.com>
Subject: Re: 3.0.0-r5: ftrace: BUG & OOPS
Date: Mon, 11 Jul 2011 19:55:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <CAHVUoiRRGY62BZOMYPYxytG569MD0=8=TEN9pCwYefDBg+J+uQ@mail.gmail.com>
In-Reply-To: <CAHVUoiRRGY62BZOMYPYxytG569MD0=8=TEN9pCwYefDBg+J+uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111955.38850.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 7 lipca 2011 o 12:23:49 Brian Marete wrote:
> Hello,
> 
> Testing 3.0.0-5, trying to echo the string '*:mod:radeon' into
> /sys/kernel/debug/tracing/set_ftrace_filter , I get the following BUG
> and Oops:

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=39162
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
