Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0DMVrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:47:08 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:54890 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0DMVrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:47:07 -0400
Date: Tue, 13 Apr 2010 23:47:01 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
       Robert Hancock <hancockrwd@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] USB: rename usb_buffer_alloc() and usb_buffer_free()
Message-ID: <20100413214701.GU30801@buzzloop.caiaq.de>
References: <20100413181631.GT30801@buzzloop.caiaq.de>
 <Pine.LNX.4.44L0.1004131525500.1551-100000@iolanthe.rowland.org>
 <20100413202607.GA3567@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413202607.GA3567@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 01:26:07PM -0700, Greg KH wrote:
> I think I will split this up into the following set of patches:
> 	- rename the functions and add a macro for the old names
> 	- rename all in-kernel usages
> 	- rename the staging tree usages
> 	- remove the macros
> 
> the first patch can go in to Linus's tree now, to make it easier for the
> 2nd and 3rd patches to live in linux-next easier as we might need to
> look at the usages in other development trees before we can add the last
> one.
> 
> Sound good?

Yes, thanks a lot.

Daniel
