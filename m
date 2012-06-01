Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab2FAPzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:55:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35339 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2FAPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:55:49 -0400
Date: Fri, 1 Jun 2012 15:01:22 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 10/94] iwlwifi: use 6000G2B for 6030 device series
Message-ID: <20120601070122.GB13229@kroah.com>
References: <20120527010425.194805088@linuxfoundation.org>
 <1338125924.20487.72.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338125924.20487.72.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 02:38:44PM +0100, Ben Hutchings wrote:
> On Sun, 2012-05-27 at 10:04 +0900, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5 upstream.
> > 
> > "iwlwifi: use correct released ucode version" change
> > the ucode api ok from 6000G2 to 6000G2B, but it shall belong
> > to 6030 device series, not the 6005 device series. Fix it
> [...]
> 
> Again, I believe this and 11/94 'iwlwifi: use correct released ucode
> version' are redundant.  Although in this series they cancel each other
> out...

You are right, thanks for the check, I've now deleted both of them from
the 3.3-stable tree.

greg k-h
