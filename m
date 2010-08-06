Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935944Ab0HFXFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:05:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58331 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935666Ab0HFXFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:05:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C5C952C.6070408@s5r6.in-berlin.de>
Date: Sat, 07 Aug 2010 01:05:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [GIT PATCH] STAGING merge for .36
References: <20100805213308.GA13744@kroah.com> <AANLkTikzUaTAAu1GqBGqNtvmpfG3z5_HjOCQoVEh9NO9@mail.gmail.com> <20100806184149.GA23308@kroah.com>
In-Reply-To: <20100806184149.GA23308@kroah.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 	git diff -M --stat --summary origin..HEAD
> 
> That's what I've been doing for a while now, and it has been working for
> the other trees.
> 
> This one was a bit different in that I did have to pull from a different
> tree for one of the drivers, but that merged together nicely from what
> the end result looked like.

/If/ that other tree is not a true descendant of origin, then

	git diff -M --stat --summary origin...HEAD
                                           ^^^
shows something else than the .. variant.  Somebody who pulls HEAD into
a tree that contains origin sees a diffstat from git pull like with from
the ... variant of git diff --stat, I think.
-- 
Stefan Richter
-=====-==-=- =--- --===
http://arcgraph.de/sr/
