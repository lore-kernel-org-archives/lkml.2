Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2CKN2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:28:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45988 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2CKN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:27:59 -0400
Date: Sun, 11 Mar 2012 13:27:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
Message-ID: <20120311132746.GA13336@n2100.arm.linux.org.uk>
References: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 06:44:25PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Instead of "in_atomic()", we can use in_interrupt() to check whether
> its an interrupt context.

What are you trying to fix?

Your description is an example of a bad commit comment.  It merely
describes the change, which anyone can see by looking at the diff.
What it totally and utterly fails to do is to describe _why_ the
change is necessary or what the problem is.

So, until it does, this patch gets a definite NAK.
