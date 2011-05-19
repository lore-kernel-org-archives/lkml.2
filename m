Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab1ESQjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:39:40 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:47443 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:39:40 -0400
Date: Thu, 19 May 2011 18:39:19 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Emil Natan <ena@isoc.org.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: df on tmpfs not reported correctly when filesystem is
 full
Message-ID: <20110519183919.79b3a605@neptune.home>
In-Reply-To: <20110519094524.GA7516@isoc.org.il>
References: <20110519094524.GA7516@isoc.org.il>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 19 May 2011 Emil Natan <ena@isoc.org.il> wrote:
> The problem seems to have been introduced in version linux-2.6.36 and
> up, it works well in 2.6.35.13. When tmpfs filesystem is full, in the
> output of df command the "Used", "Available" and  "Use%" the numbers
> are replaced with hyphens:
> 
> # df /images/1
> Filesystem           1K-blocks      Used Available Use% Mounted on
> tmpfs                     1024         -         -   -  /images/1
> 
> Here is how it looks with "good" and "bad" kernel and how to reproduce
> the issue. Please let me know if more debug information is needed in
> a mail cc-ied directly to me.

This was fixed in 2.6.39 (now released) with following patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fc5da22ae35d4720be59af8787a8a6d5e4da9517

It's already queued for stable so it should show up there soon.

Bruno
