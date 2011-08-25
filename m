Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab1HYQBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1HYQB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:01:29 -0400
Date: Thu, 25 Aug 2011 17:57:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jovi Zhang <bookjovi@gmail.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110825155735.GA5380@redhat.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <4E527684.3020206@draigBrady.com> <20110822161914.GA9399@redhat.com> <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com> <20110824110134.GA17362@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824110134.GA17362@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Neil Horman wrote:
>
> The long and the short of it is, making RLIMIT_CORE == 0 for the ispipe case
> skip the core dump, breaks lots of user space expectations

Not sure this really makes sense, but perhaps ispipe can skip the dump
if RLIMIT_CORE == 0 _and_ the signal was sent from the user-space.

Oleg.

