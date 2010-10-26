Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0JZBOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:14:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0JZBO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JHAWafvoLClkYJ2ve/A5WEVA4IfnvQ0wns7n7mGaG54b/UnvtFsajWbxbjN+Nr5W3W
         l0pYsNL2zGB0A1BvvZCQxfHj44D7LcX7HjIUqpfb+qqy5byTSd9aCFWKwDWKyyCvQk4O
         6OU6QISI5xJyiP6LIqA8M+O9GOO66Rjbd0XcQ=
Subject: Re: [PATCH 02/29] memstick: core: reorder functions This patch
 just reorders functions in memstick.c So that host specific and card driver
 specific functions are now grouped together. This makes it easier to
 understand the code.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <779344.19696.qm@web37603.mail.mud.yahoo.com>
References: <779344.19696.qm@web37603.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:14:23 +0200
Message-ID: <1288055663.4024.25.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 07:50 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 02/29] memstick: core: reorder functions This patch just reorders functions in memstick.c So that host specific and card driver specific functions are now grouped together. This makes it easier to understand the code.
> 
> 
> I'm not sure this purely subjective patch is of any real utility.
> And at any rate, it belongs to the end of the patchset (where the clean-up
> normally go), not to the beginning.

Could somebody else comment on this?
I mean memstick.c/h contains two types of functions.
One is useful only for low level drivers, and other only for high level
drivers. Whats wrong with at least grouping that together?
It probably even better to put them to separate files...

As for doing that late, I exaplained that once in reply to Morton.
It was much easier to split patches this way, and really doesn't matter
otherwise.

Best regards,
	Maxim Levitsky

