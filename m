Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab2FQVJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:09:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60675
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273Ab2FQVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:09:30 -0400
Date: Sun, 17 Jun 2012 17:09:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hfsplus fixes for Linux 3.5
Message-ID: <20120617210929.GA29127@infradead.org>
References: <20120617210523.088906451@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120617210523.088906451@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 05:05:23PM -0400, Christoph Hellwig wrote:
> Two small hfsplus fixes:
> 
>  - a one liner regression fix for large volume handling from

Sorry, chopped off the message, should be:

Two small hfsplus fixes:

 - a one liner regression fix for large volume handling from
   Janne Kalliom??ki.
 - a fixup for the boot image blessing feature to make it work
   with the fake "hardlinks" in hfsplus from Matthew Garrett.

