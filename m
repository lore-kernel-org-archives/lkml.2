Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2DKQAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:00:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64646 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759793Ab2DKQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:00:44 -0400
Date: Wed, 11 Apr 2012 09:00:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 117/175] iommu/amd: Make sure IOMMU interrupts are re-enabled
 on resume
Message-ID: <20120411160039.GB31288@kroah.com>
References: <20120330194849.232840068@linuxfoundation.org>
 <1333423686.443.37.camel@deadeye>
 <20120411154522.GH2428@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411154522.GH2428@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 05:45:22PM +0200, Joerg Roedel wrote:
> Right, this fix is also required for 3.2 and 3.0.

Wait, what?

Can someone send me the needed fix, in a new thread as I seem to have
lost this one :(

thanks,

greg k-h
