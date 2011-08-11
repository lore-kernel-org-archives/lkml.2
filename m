Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1HKQGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1HKQGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:06:44 -0400
Date: Thu, 11 Aug 2011 18:03:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
Message-ID: <20110811160358.GA7989@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 08/11, Matt Fleming wrote:
>
> I did a tree wide scan of all the code that modifies current->blocked
> without using the set_current_blocked() accessor. This patch series is
> the result of the conversion to the new accessor functions.

Yes, this is what I was going to do, but didn't find time ;)

Thanks, everything looks "obviously fine" at first glance. except
ncpfs does something mysterious (and afaics wrong) with or without
the patch.

I'll try to read this carefully on weekend though. I do not expect I'll
find any problem, just may be a couple of nits about the changelogs.
Say, 41/41... doesn't hurt, but in fact the current code is fine as is.

Oleg.

