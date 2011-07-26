Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1GZGcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:32:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab1GZGch convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110726051533.GA2835@kroah.com>
References: <20110726051533.GA2835@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Jul 2011 23:31:48 -0700
Message-ID: <CA+55aFwOgkOXmY654-qbuiFFnUC1yXZ27DBDFR02JP12NxAF9w@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING patches for 3.1
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:15 PM, Greg KH <greg@kroah.com> wrote:
>
> Note, I have not successfully merged this with your tree yet, the
> diffstat below is against the 3.0-rc6 tree.  When merging with your
> tree, there are a number of merge issues that I trust you can resolve
> easier than I can.  If you have problems, please let me know and I will
> fix them up on Wednesday when I get done driving to my next hotel
> location.

No problem, some of the merge conflicts looked a bit ugly, but they
were all trivial. Most of them was due to some trivial removed or
added #include lines, and it just then clashed with your much bigger
changes. Easy enough to sort out, and in couple of cases the bigger
changes had just made the small changes irrelevant too.

So all merged and pushed out. Of course, maybe I made a mistake
somewhere, but none of it looked at all questionable (famous last
words ;)

                   Linus
