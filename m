Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab0HQQEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:04:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:46482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab0HQQEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:04:06 -0400
Date: Tue, 17 Aug 2010 08:54:00 -0700
From: Greg KH <gregkh@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nelson Zhang <nxz@cypress.com>, "'David Cross'" <david.cross@cypress.com>,
        hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100817155400.GA18430@suse.de>
References: <20100813192826.GA5078@suse.de> <1281731535.29175.17.camel@odc-laptop> <20100813221749.GA19569@suse.de> <1281741733.22119.20.camel@odc-laptop> <20100814002514.GA3182@suse.de> <1281748363.7882.15.camel@odc-laptop> <20100814030408.GB4779@suse.de> <ABE41F255A574632903665A7D1F90907@mis.cypress.com> <20100817145403.GA28926@suse.de> <20100817154038.GA29448@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817154038.GA29448@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:40:38AM -0400, Christoph Hellwig wrote:
> On Tue, Aug 17, 2010 at 07:54:03AM -0700, Greg KH wrote:
> > On Mon, Aug 16, 2010 at 06:57:54AM +0800, Nelson Zhang wrote:
> > > Hi David, Greg,
> > > 
> > > What I have done so far is following:
> > > 
> > > 1. Open a file 
> > > 2. Seek to the end of file
> > 
> > That just created a "sparse file"
> 
> Not on FAT which doesn't support sparse files.

Ah, didn't realize that fat didn't support that, thanks.
