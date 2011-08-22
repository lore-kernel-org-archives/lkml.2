Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1HVNa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:30:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1HVNa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:30:26 -0400
Date: Mon, 22 Aug 2011 15:27:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, dhowells@redhat.com,
        roland@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110822132716.GA28333@redhat.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <CACV3sbL3j7qDPq=Dadnsw3HZCokF5V_tnGPhfocP-b1haQq_=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACV3sbL3j7qDPq=Dadnsw3HZCokF5V_tnGPhfocP-b1haQq_=g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Jovi Zhang wrote:
>
> I will resend the patch for fix the comments.

Yes, please ;)

While at it, could you add something like

	* See umh_pipe_setup() which sets RLIMIT_CORE = 1.

at the start of this comment? Unless you know how the code works
it is not obvious where this "1" comes from.

Oleg.

