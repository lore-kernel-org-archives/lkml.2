Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1KGSMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:12:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab1KGSMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:12:45 -0500
Date: Mon, 7 Nov 2011 10:10:57 -0800
From: Greg KH <gregkh@suse.de>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] readlinkat: ensure we return ENOENT for the empty
 pathname for normal lookups
Message-ID: <20111107181057.GA5474@suse.de>
References: <1312455634-16253-1-git-send-email-apw@canonical.com>
 <1312455634-16253-2-git-send-email-apw@canonical.com>
 <4EB74A96.2080209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB74A96.2080209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 11:03:50AM +0800, Wanlong Gao wrote:
> Hi Greg:
> 
> I see that this patch was queued to stable 3.0 and 3.1, and I wanna know
> will it be merged to v3.0.9, v3.1.1?

That is exactly what being queued for the next stable release means, so
yes, it will be included in those next releases, when they happen,
hopefully sometime later this week.

greg k-h
