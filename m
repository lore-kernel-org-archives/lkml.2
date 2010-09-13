Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0IMRsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:48:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab0IMRsg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <20100913170515.GA8943@kroah.com>
References: <20100913170515.GA8943@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Sep 2010 10:41:37 -0700
Message-ID: <AANLkTinA30LGPUMrL_5tLaB+rLUAv7AAutZwiZCW2qJJ@mail.gmail.com>
Subject: Re: Linux 2.6.34.7
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        stable@kernel.org, lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:05 AM, Greg KH <gregkh@suse.de> wrote:
>
> It fixes a single bug that a number of users have reported in that their
> USB devices no longer work properly.  Sometimes it causes lost
> keystrokes, and other times X refuses to boot as it can not communicate
> properly with some tablet devices.

So just out of interest, why is that commit ok and doesn't need to be
reverted in 36-rc? The comments in the commit message do not explain.

                                Linus
