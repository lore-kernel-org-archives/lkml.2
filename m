Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2AKHli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:41:38 -0500
Received: from verein.lst.de ([213.95.11.211]:44584 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab2AKHlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:41:37 -0500
Date: Wed, 11 Jan 2012 08:41:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
        Ben Myers <bpm@sgi.com>
Subject: Re: [41/42] xfs: validate acl count
Message-ID: <20120111074135.GA30829@lst.de>
References: <20120110215031.GA19398@kroah.com> <20120110215024.482323323@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110215024.482323323@clark.kroah.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 01:48:51PM -0800, Greg KH wrote:
> 3.1-stable review patch.  If anyone has any objections, please let me know.

Just curious, how well tested are all the patches on 2.6.32 and 3.1 hat I only
submitted for 3.0?  I'd really prefer if they at least get an xfstest run
before they get sent out to the world.

