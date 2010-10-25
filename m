Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab0JYQIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:08:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab0JYQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:08:02 -0400
Date: Mon, 25 Oct 2010 09:07:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/29] My patch queue for memorystick subsystem
Message-Id: <20101025090721.c5d3fdc6.akpm@linux-foundation.org>
In-Reply-To: <408703.12417.qm@web37603.mail.mud.yahoo.com>
References: <1287972070.5205.12.camel@maxim-laptop>
	<408703.12417.qm@web37603.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 07:39:58 -0700 (PDT) Alex Dubov <oakad@yahoo.com> wrote:

> Normally, functional
> patches should precede the cosmetic one, so that the functionality can be
> discussed first.

More usually it's the other way around, actually: cleanups come first.

Because the cleanups are usually uncontroversial, and because
substantive changes against cleaner code are easier to
review/understand and because the substantive changes are then easier
to revert or fix.
