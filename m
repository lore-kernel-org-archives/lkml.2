Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2BFSaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:30:18 -0500
Received: from 1wt.eu ([62.212.114.60]:62253 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab2BFSaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:30:16 -0500
Date: Mon, 6 Feb 2012 19:30:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 41/91] xen/smp: Warn user why they keel over - nosmp or noapic and what to use instead.
Message-ID: <20120206183004.GB18059@1wt.eu>
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220951.204993240@pcw.home.local> <20120206165040.GB23240@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206165040.GB23240@phenom.dumpdata.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 11:50:40AM -0500, Konrad Rzeszutek Wilk wrote:
> On Sun, Feb 05, 2012 at 11:10:30PM +0100, Willy Tarreau wrote:
> > 2.6.27-longterm review patch.  If anyone has any objections, please let us know.
> 
> Please drop this patch. The 2.6.27 did not have dom0 functionality so it
> will never hit this error path.

Fine, thank you Konrad.

Best regards,
Willy

