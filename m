Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1AUS1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:27:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab1AUS1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:27:03 -0500
Date: Fri, 21 Jan 2011 10:26:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
Message-Id: <20110121102654.fd87c917.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1101211434210.3490@dc5850.croftnuisk.local>
References: <4D2DEDDB.1070605@gmail.com>
	<20110119154915.a0bb2878.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1101211434210.3490@dc5850.croftnuisk.local>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 14:43:14 +0000 (GMT) Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:

> > Was `mount -o remount,ftsuffix=1' implemented and tested?
> 
> I didn't specifically check it out with remount.  Is that likely to be a
> problem?

It should work and should be tested and maintained.

I do worry about the effect on userspace of having all the filenames
change on the fly.  I guess if it makes applications misbehave then
that's a userspace (administrator) error.

Does it mean that existing dcache entries are now out of sync, so some
filenames are suffixless and others are suffixed?  If so, that might be
too hard to fix, and some way of disabling `mount -o remount' should be
found.

> > Am I correct in assuming that "mount -o remount,ftsuffix=0" turns this
> > off again?

That too.
