Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1H0OFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:05:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1H0OFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:05:17 -0400
Date: Sat, 27 Aug 2011 16:05:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 8/8] res_counter: Allow charge failure pointer to be null
Message-ID: <20110827140511.GL3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-9-git-send-email-fweisbec@gmail.com>
 <4E4B2B06.4010108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B2B06.4010108@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:44:22AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > So that callers of res_counter_charge() don't have to create and
> > pass this pointer even if they aren't interested in it.
> > 
> 
> Why not make this change early, or even do this in "[PATCH 5/8]".

Would be more simple yeah.
