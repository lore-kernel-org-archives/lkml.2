Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1EaTwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:52:05 -0400
Received: from 1wt.eu ([62.212.114.60]:36541 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107Ab1EaTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:52:04 -0400
Date: Tue, 31 May 2011 21:52:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
Message-ID: <20110531195201.GB7995@1wt.eu>
References: <4DE3E9E7.8020008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3E9E7.8020008@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
> Hi all,
> 
> With the v3.0 name change I was looking over what might break, and I'm
> seriously considering turning off the incremental diff robot on
> kernel.org.  It's not clear to me that it is actually useful anymore,
> with git and all.
> 
> Do anyone actually use these anymore?

Well, I don't think the incremental patches are *that much* used.
Speaking for my case, my longterm release scripts do produce them
anyway since it's trivial with git, and I suppose many others do
as well.

I suggest that we disable the robot and wait for any possible
complaints which are to be expected anyway with a version change.
Then it'll be more productive to help tree owners to adapt their
scripts than it would be to keep the robot running.

Just my 2 cents,
Willy

