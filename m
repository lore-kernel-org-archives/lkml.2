Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0GVTPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:15:36 -0400
Received: from kroah.org ([198.145.64.141]:38169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab0GVTPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:15:33 -0400
Date: Thu, 22 Jul 2010 12:14:57 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] zcache: page cache compression support
Message-ID: <20100722191457.GA13309@kroah.com>
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 06:07:42PM +0530, Nitin Gupta wrote:
> Frequently accessed filesystem data is stored in memory to reduce access to
> (much) slower backing disks. Under memory pressure, these pages are freed and
> when needed again, they have to be read from disks again. When combined working
> set of all running application exceeds amount of physical RAM, we get extereme
> slowdown as reading a page from disk can take time in order of milliseconds.

<snip>

Given that there were a lot of comments and changes for this series, can
you resend them with your updates so I can then apply them if they are
acceptable to everyone?

thanks,

greg k-h
