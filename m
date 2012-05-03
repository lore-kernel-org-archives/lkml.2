Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab2ECTsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:48:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55164 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab2ECTsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:48:17 -0400
Message-ID: <1336074483.6509.3.camel@twins>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 21:48:03 +0200
In-Reply-To: <1336004953.4240.9.camel@mop>
References: <1336004953.4240.9.camel@mop>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 02:29 +0200, Kay Sievers wrote:
> + * This is printk(). It can be called from any context. We want it to work.

This is not true..
