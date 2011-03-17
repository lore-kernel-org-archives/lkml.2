Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1CQAUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:20:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab1CQAUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110316210300.GA3311@kroah.com>
References: <20110316210300.GA3311@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 17:19:47 -0700
Message-ID: <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING patches for .39
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 2:03 PM, Greg KH <greg@kroah.com> wrote:
> Here is the big staging tree merge for .39

So I try to compile all the staging drivers every once in a while.

This time I gave up even trying. After the GMA500 driver didn't
compile (due to some crazy patch to dri_pci_init() that changes it to
a calling convention that it has never had), there was another file
that spewed out about five thousand lines of error/warning messages.

Aren't those things supposed to at least compile? What's going on?

                          Linus
