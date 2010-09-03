Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0ICNbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:31:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0ICNbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:31:52 -0400
Date: Fri, 3 Sep 2010 09:31:50 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] Fix PA-RISC irqflags
Message-ID: <20100903133150.GI2684@bombadil.infradead.org>
References: <20100903014042.GH2684@bombadil.infradead.org>
 <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
 <20100827020043.27277.2926.stgit@warthog.procyon.org.uk>
 <7137.1283496507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7137.1283496507@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 07:48:27AM +0100, David Howells wrote:
> Kyle McMartin <kyle@mcmartin.ca> wrote:
> 
> > Should I merge this, or are you going to push this with some larger
> > changes?
> 
> This will need to be merged into the main patch before that is submitted, but
> if I can have your Acked-by, I can include that specifically for the PA-RISC
> bits.
> 

Please do:

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
