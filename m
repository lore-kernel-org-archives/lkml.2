Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0LWKlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:41:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48355 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0LWKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:41:45 -0500
MIME-Version: 1.0
X-Originating-IP: [192.163.20.231]
Date: Thu, 23 Dec 2010 16:11:43 +0530
Message-ID: <AANLkTikgHBVoPiPTXumcBn-t620=6xy+=2AaY3WYPmmY@mail.gmail.com>
Subject: staging-tree: to stage or not to stage
From: Pavan Savoy <pavan_savoy@sify.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

<long mail warning...>

We've been having this discussion here and there, and there has been
various opinions about what staging is,
I've also read your mail @ http://lwn.net/Articles/285594/ on what the
tree IS and what it is NOT.

So, hoping you dispel all opinions and lay down some facts!!!

I think there is an opinion floating around that drivers in staging
lack some functionality or
don't work as expected or is just plain bad. (which might be true for
some drivers, but would be hard
on lot of people/drivers to generalize, I doubt any developer posting
to lkml would be irresponsible
enough to post an un-tested code...)

The reason I would stage any driver (if it is a self-containable
device driver) for that fact that a lot
of drivers get posted on lkml or other related sub-system list and
they keep on getting reviewed,
multiple versions come and go, and sometimes it so happens that all
the review comments are taken
care of, and MAINTAINER only comes back to say he wouldn't accept the
driver because he doesn't LIKE
it or thinks the underlying/related drivers is not good enough ....

So, why not stage everything, may be except few drivers which are
written by the MAINTAINERs themselves,
put up a TODO, get MAINTAINERs to review TODO, and get them to common
understanding that once the items in TODO are completed, it would be
in mainline...
As of today If I get 5 comments on my driver, I am not sure fixing
those 5 comments actually gets it to
mainline :(

regards,
Pavan
