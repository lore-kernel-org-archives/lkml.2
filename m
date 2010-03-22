Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0CVX4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:56:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab0CVX4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:56:20 -0400
Date: Mon, 22 Mar 2010 16:52:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: =?ISO-8859-7?Q?Re=3A_Compile_error_in_latest_-git=3A_ipc=2Fsyscall=2Ec=3A17=3A_error=3A_conflicting_types_for_=A1sys=5Fipc=A2?=
In-Reply-To: <4BA7C6B7.4030203@gmail.com>
Message-ID: <alpine.LFD.2.00.1003221651370.18017@i5.linux-foundation.org>
References: <4BA7C6B7.4030203@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Mar 2010, Kevin Winchester wrote:
> 
> In case this hasn't been reported before, I get the following compile error
> with latest git:

It's already fixed in my tree, but I forgot to push out the end result. 
Pushed out now.

		Linus
