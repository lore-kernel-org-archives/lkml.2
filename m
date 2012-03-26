Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2CZV3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:29:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2CZV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:29:10 -0400
Date: Mon, 26 Mar 2012 14:29:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net, pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-Id: <20120326142908.c5248aec.akpm@linux-foundation.org>
In-Reply-To: <20120326180710.8DF9C9D401E@zog.reactivated.net>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 19:07:07 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Add a debugfs interface for sending commands to the OLPC Embedded
> Controller (EC) and reading the responses.  The EC provides functionality
> for machine identification, battery and AC control, wakeup control, etc.
> 
> Having a debugfs interface available is useful for EC development and
> debugging.
> 
> Based on code by Paul Fox.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> Originally-from: Paul Fox <pgf@laptop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andres Salomon <dilinger@queued.net>
> 
> ...
>
> v4: really fix sign-off tags

s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
is based upon an earlier version from Paul then Signed-off-by: is
correct.

What's going on here?  What are you trying to communicate?
