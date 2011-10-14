Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1JNUv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:51:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36479 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1JNUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:51:25 -0400
Date: Fri, 14 Oct 2011 13:51:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Ballard <dan@mindstab.net>
Cc: Ingo Molnar <mingo@elte.hu>, Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] added code to export CAP_LAST_CAP in
 /proc/sys/kernel modeled after ngroups_max
Message-Id: <20111014135122.4bb95565.akpm@linux-foundation.org>
In-Reply-To: <1318460194-31983-1-git-send-email-dan@mindstab.net>
References: <1318460194-31983-1-git-send-email-dan@mindstab.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 15:56:34 -0700
Dan Ballard <dan@mindstab.net> wrote:

> In response to a request by the Linux Plumbers about getting CAP_LAST_CAP exposed somehow, I talked to Lennart Poettering briefly and went ahead and added cap_last_cap to /proc/sys/kernel in a similar fashion as ngroups_max is exported.  The patch is simple and just adds another struct to the array of exported values in sysctl.c.
> 

The changelog should explain the reason for making this change, please.
People aren't going to remember some vague email thread five years
from now.

Also, please update the documentation.  Documentation/sysctl/kernel.txt
is a suitable place.  Lots of things in kern_table[] are undocumented,
but that's not a reason for the rest of us to suck as much as sched
developers :)

