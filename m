Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2CJG0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 01:26:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39178 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2CJGZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 01:25:58 -0500
MIME-Version: 1.0
In-Reply-To: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
Date: Fri, 9 Mar 2012 22:25:58 -0800
Message-ID: <CABCjUKBZ_DLJC6Z4s33cFAmCYJW7uiee+ziwDydDZ7tYdWgM0A@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Memcg Kernel Memory Tracking.
From: Suleiman Souhlal <suleiman@google.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Cc: cgroups@vger.kernel.org, glommer@parallels.com,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, cl@linux.com,
        yinghan@google.com, hughd@google.com, gthelen@google.com,
        peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org,
        mgorman@suse.de, James.Bottomley@hansenpartnership.com,
        linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 12:39 PM, Suleiman Souhlal <ssouhlal@freebsd.org> wrote:
> This is v2 of my kernel memory tracking patchset for memcg.

I just realized that I forgot to test without the config option
enabled, so that doesn't compile. :-(

I will make sure to fix this in v3 and test more thoroughly.

Hopefully this shouldn't impede discussion on the patchset.

Sorry about that.
-- Suleiman
