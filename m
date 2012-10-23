Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab2JWWRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:17:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154Ab2JWWRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:17:00 -0400
Date: Tue, 23 Oct 2012 15:16:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Leach <matthew@mattleach.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] init: Use the stringify operator for the
 __define_initcall macro
Message-Id: <20121023151659.5aa076ce.akpm@linux-foundation.org>
In-Reply-To: <1351022429-3242-1-git-send-email-matthew@mattleach.net>
References: <1351022429-3242-1-git-send-email-matthew@mattleach.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 21:00:29 +0100
Matthew Leach <matthew@mattleach.net> wrote:

> Currently the __define_initcall macro takes three arguments, fn, id
> and level. The level argument is exactly the same as the id argument
> but wrapped in quotes. To overcome this need to specify three
> arguments to the __define_initcall macro, where one argument is the
> stringification of another, we can just use the stringification macro
> instead.
> 
> Signed-off-by: Matthew Leach <matthew@mattleach.net>
> ---
> v2: Fix a build error where the ppc arch also uses the
> __define_initcall macro. Also fix some styling issues.

OK, let's try that.

Is arch/um/include/shared/init.h OK as-is?
