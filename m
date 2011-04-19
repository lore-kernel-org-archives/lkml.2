Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1DSSKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:10:23 -0400
Received: from kroah.org ([198.145.64.141]:44401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1DSSKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:10:22 -0400
Date: Tue, 19 Apr 2011 11:10:13 -0700
From: Greg KH <greg@kroah.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] char: agp: fix OOM and buffer overflow
Message-ID: <20110419181013.GA12437@kroah.com>
References: <1302800120-31560-1-git-send-email-segoon@openwall.com>
 <20110419162157.GD23196@kroah.com>
 <20110419174813.GA27544@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419174813.GA27544@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 09:48:13PM +0400, Vasiliy Kulikov wrote:
> On Tue, Apr 19, 2011 at 09:21 -0700, Greg KH wrote:
> > David, what ever happened to this, and the other agp bugfix from
> > Vasiliy?
> 
> I got emails that both fixes went into -mm.

That's good, but David needs to take them and push them to Linus...

