Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0C2JNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:13:00 -0400
Received: from ozlabs.org ([203.10.76.45]:44950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0C2JM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:12:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: Is module refcounting racy?
Date: Mon, 29 Mar 2010 19:42:56 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20100318105533.GE25636@laptop>
In-Reply-To: <20100318105533.GE25636@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003291942.56706.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 09:25:34 pm Nick Piggin wrote:
> Hey,
> 
> I've been looking at weird and wonderful ways to do scalable refcounting,
> for the vfs...
> 
> Sadly, module refcounting doesn't fit my bill. But as far as I could see,
> it is racy.

Other than for advisory purposes, the refcount is only checked against zero
under stop_machine.  For exactly this reason.

Hope that helps,
Rusty.
