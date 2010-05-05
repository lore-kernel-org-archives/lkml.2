Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542Ab0EEKrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:47:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58169 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753291Ab0EEKq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:46:58 -0400
Date: Wed, 5 May 2010 11:52:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 00/13] BKL conversion in tty layer
Message-ID: <20100505115205.7d2abc4f@lxorguk.ukuu.org.uk>
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 May 2010 00:33:39 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> This is the second attempt to get the BKL out of the
> TTY code. I've updated the patches to be based on top
> of Alan's series and improved a number of things.

I've updated the patches I first sent out with the fixes for the problems
you found and send out a new set.

