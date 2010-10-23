Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0JWLqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:46:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab0JWLqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:46:07 -0400
Date: Sat, 23 Oct 2010 07:46:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101023114604.GA23814@infradead.org>
References: <20101022175112.GC13489@kroah.com>
 <1287771688-14805-28-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287771688-14805-28-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 11:21:07AM -0700, Greg Kroah-Hartman wrote:
> From: Dr. Werner Fink <werner@suse.de>
> 
> Add a new file /proc/tty/consoles to be able to determine the registered
> system console lines.  If the reading process holds /dev/console open at
> the regular standard input stream the active device will be marked by an
> asterisk.  Show possible operations and also decode the used flags of
> the listed console lines.

Err, no way we can put in code that walks the fd table and poke into
random private data for a magic number.

NAK.

