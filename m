Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1GWB1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:27:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56507 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1GWB1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:27:13 -0400
Date: Sat, 23 Jul 2011 02:27:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs patches for 3.1, part 1
Message-ID: <20110723012712.GG31405@ZenIV.linux.org.uk>
References: <20110723000131.GE31405@ZenIV.linux.org.uk>
 <CA+55aFxsCqAuFdz3F6j1ecgo-OHVCSzicAims76-BchOnJqHYQ@mail.gmail.com>
 <CA+55aFxwyCS+G5g-EdL48TPd7saU+3wCWPf3EBoY7Amf+tb7Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwyCS+G5g-EdL48TPd7saU+3wCWPf3EBoY7Amf+tb7Qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 05:54:15PM -0700, Linus Torvalds wrote:

> *Most*, but not all, of the commits you list seem to exist in the
> for-next branch.

The rest is a build fix from Randy + obvious ERR_CAST-instead-of-cast +
isofs lock removal + a couple of IN_DELETE_SELF fixes that should've gone
in last cycle...
 
> Which is identical to the "untested" branch, so that, together with
> the "not everything listed in your shortlog is there" makes me not get
> the warm and fuzzies.

#untested == #master in my local tree, no more than that...  My apologies
about the forgotten push.
