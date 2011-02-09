Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab1BIFqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 00:46:14 -0500
Received: from 1wt.eu ([62.212.114.60]:60441 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab1BIFqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 00:46:14 -0500
Date: Wed, 9 Feb 2011 06:46:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Jayson R. King" <dev@jaysonking.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>
Subject: Re: [stable] 2.6.27.58-rc1 build error Re: [PATCH 20/23] tracing: Fix panic when lseek() called on "trace" opened for writing
Message-ID: <20110209054604.GE16288@1wt.eu>
References: <4D520535.6080408@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D520535.6080408@jaysonking.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:08:37PM -0600, Jayson R. King wrote:
> Looks like a typo was made in this patch for 2.6.27.58-rc1:
> 
> 	kernel/trace/trace.c:2055: error: 'tracing_lseek' undeclared here 
> 	(not in a function)
> 
> 
> 
> 'tracing_lseek' likely should be 'tracing_seek' in the two occurances in 
> this patch.

Thanks for checking Jayson. I've fixed it now. You're right, I mangled
it when applying it by hand. Unfortunately my .config did not enable
this part :-/

Thanks,
Willy

