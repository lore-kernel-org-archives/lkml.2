Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1LBIfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:35:00 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46214
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab1LBIe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:34:59 -0500
Date: Fri, 2 Dec 2011 03:34:51 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: tytso@mit.edu, tm@tao.ma, lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ext4: auto batched discard support at kernel thread
Message-ID: <20111202083451.GA7345@infradead.org>
References: <20111202060424.GA26155@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202060424.GA26155@july>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 03:04:24PM +0900, Kyungmin Park wrote:
> Hi,
> 
> It's proof of concept to run kernel thread for batched discard.
> 
> Now it can run fitrim at user level. but it's not clear which deamon run this activity.

fstrim from a cron job.

> In case of android platform, the launcher is candidate 
> but user can change the default launcher then it can't use the fitrim any more.

Android beeing broken as shit is no reason to push useless code into the
kernel.

