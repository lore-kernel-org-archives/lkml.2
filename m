Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab2CLCt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:49:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46101 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab2CLCtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:49:50 -0400
X-Sasl-enc: CT59VsQBzpcHA5xSmGXcBjlfK4iM0Yo/UHYep58qlvKH 1331520589
Date: Sun, 11 Mar 2012 19:49:48 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
Message-ID: <20120312024948.GB4650@kroah.com>
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331514446.3022.140.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 01:07:26AM +0000, Ben Hutchings wrote:
> On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> The subject/first line should include '[IA64]', as in the original
> commit.  It looks like this has been automatically stripped.

Yeah, munging patches to and from quilt and git will cause that to
happen at times, it's quite common :(

greg k-h
