Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1HBVLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:11:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43634 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1HBVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:11:26 -0400
Date: Wed, 3 Aug 2011 00:09:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Use kstrdup rather than duplicating its implementation
Message-ID: <20110802210922.GC3839@shale.localdomain>
References: <1312302089.2629.15.camel@localhost.localdomain>
 <20110802180537.GB3839@shale.localdomain>
 <1312313657.2629.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312313657.2629.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 09:34:14PM +0200, Thomas Meyer wrote:
> Does somebody maybe have a script for doing this split of an mbox file?
> maybe this script could also call get_maintainer.pl and change the To:
> field accordingly?
> 
> Just asking...

Checking it by hand builds character.  :)  Reviewers have to check
each patch by hand for mistakes and malice so this serves as a small
test to see if it's worth bothering maintainers about it.

regards,
dan carpenter
