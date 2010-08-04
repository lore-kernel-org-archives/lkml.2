Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0HDHAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:00:50 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60686 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab0HDHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:00:48 -0400
Message-Id: <201008040700.o7470LWi021902@www262.sakura.ne.jp>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Valdis.Kletnieks@vt.edu
Cc: hch@infradead.org, jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@ftp.linux.org.uk, kees.cook@canonical.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Aug 2010 16:00:21 +0900
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org> <20100802165936.GV3948@outflux.net> <15424.1280775073@localhost> <20100803165010.GG3948@outflux.net> <78690.1280871500@localhost> <201008040354.o743sWTv078792@www262.sakura.ne.jp> <5029.1280902716@localhost>
In-Reply-To: <5029.1280902716@localhost>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 04082010 #3892565, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> Are you sure you weren't running in permissive mode when you tested this?
I'm running CentOS5.5 and RHEL6beta in enforcing mode with default configuration
(TARGETED policy).

> I am unable to replicate this behavior on my system with SELinux set to
> enforcing mode.  However, it does happen (which is to be expected) when SELinux
> is set to permissive mode.
So, MLS policy can stop this case, can't it? That's fine.

But most people is using TARGETED policy, isn't it?
How do you provide protection to those who don't use MLS policy?

SSHD case is just an example which everyone can try handily.
What I want to say is that it is up to application that how the application
uses information if the application is allowed to access the information. Thus,
we should try to control parameters that affect how the information is used
as much as possible in addition to controlling whether the application can
reach the information or not.
