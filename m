Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0ENQ6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:58:15 -0400
Received: from atlas.linux2go.dk ([88.198.22.52]:52528 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab0ENQ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:58:13 -0400
Date: Fri, 14 May 2010 18:50:36 +0200
From: Soren Hansen <soren@linux2go.dk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Allow hvc tty's to pose as vt's
Message-ID: <20100514165036.GA3802@linux2go.dk>
References: <cover.1273825543.git.soren@linux2go.dk>
 <0dd0991d71cac0a746891863264941c100bbc67a.1273825543.git.soren@linux2go.dk>
 <20100514174348.74b74821@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514174348.74b74821@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 05:43:48PM +0100, Alan Cox wrote:
>> Allow for hvc based tty's to take over the vt driver's major number
>> and namespace.
> We've got a perfect good udev and symlink functionality to rename
> devices in userspace.

I agree in principle. The reason this really is necessary for us
(Rackspace) is that we have tons of customers running tons and tons of
these virtual machines, and we can't (well, of course we /could/, but
that'd be horrible) go around and change people's virtual machines to
accomodate changes we want to make on the hypervisor side.

> NAK.

Fair enough. I really just wanted to share it in case someone else would
find it useful.

-- 
Soren Hansen
System Architect, The Rackspace Cloud
Ubuntu Developer
