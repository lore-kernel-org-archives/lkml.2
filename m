Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab0EEKvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:51:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58181 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752689Ab0EEKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:51:43 -0400
Date: Wed, 5 May 2010 11:57:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 02/13] tty: make atomic_write_lock release tty_lock
Message-ID: <20100505115712.66c6b010@lxorguk.ukuu.org.uk>
In-Reply-To: <1273012433-6125-3-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
	<1273012433-6125-3-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 May 2010 00:33:41 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> atomic_write_lock never nests below BTM as far
> as I can tell, so this can eventually get
> reverted again unless it triggers bugs.

That appears correct to me as a working assumpion as well
