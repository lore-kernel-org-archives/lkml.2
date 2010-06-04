Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999Ab0FDECA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:02:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0FDEB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:01:59 -0400
Date: Fri, 4 Jun 2010 05:01:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mount namespace : who mounted what ?
Message-ID: <20100604040158.GZ31073@ZenIV.linux.org.uk>
References: <4C080ABD.5040902@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C080ABD.5040902@free.fr>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:04:13PM +0200, Daniel Lezcano wrote:
> Hi all,
> 
> I was wondering, in a new mount namespace, if it is possible to know
> which mount points were inherited and which were mounted in a new
> namespace ?
> 
> I looked at /proc/<pid>/mountinfo and investigated a bit on the
> mount id, but this one is not reliable as it changes in the new
> namespace. The /proc/<pid>/mounts file shows all the mount points
> visible for the process inherited or not.

No more than "had it been this process that mmaped that area or was it
inherited from the parent?"
