Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2KRTdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:33:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64358 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2KRTdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:33:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAGjg+kGKagtybwb+dTW8QVyhrjrQmfyPM9tv8asFQsP=z39suw@mail.gmail.com>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org> <CAGjg+kGKagtybwb+dTW8QVyhrjrQmfyPM9tv8asFQsP=z39suw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Nov 2012 09:32:57 -1000
X-Google-Sender-Auth: iMLqWD7C-K3-w8JhoPIDCHedeXQ
Message-ID: <CA+55aFwc2q+oRohTxgwdydMPvivXjajX970qEmO_-GP4SFdPdw@mail.gmail.com>
Subject: Re: [PATCH 00/31] Latest numa/core patches, v15
To: Alex Shi <lkml.alex@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 10:45 PM, Alex Shi <lkml.alex@gmail.com> wrote:
> had caught a ops on my 2 sockets SNB EP server. but can not reproduce it.
> send out as a reminder:
> on tip/master, head : a7b7a8ad4476bb641c8455a4e0d7d0fd3eb86f90

This is an independent bug, nothing to do with the NUMA stuff. Fixed
in my tree now (commit 3587b1b097d70).

Of course, it's entirely possible that the NUMA patches are subtly
buggy and helped trigger the fanotify OVERFLOW event that had this
particular bug. But the oops itself is due to a real bug.

           Linus
