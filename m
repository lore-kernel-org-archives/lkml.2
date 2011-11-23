Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1KWRAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:00:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:47603 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab1KWRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:00:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="79250898"
Date: Wed, 23 Nov 2011 09:00:06 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Aman Deep <amandeep3986@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xHCI: Adding #define values used for hub descriptor
Message-ID: <20111123170006.GB5792@xanatos>
References: <1321970616-1298-1-git-send-email-amandeep3986@gmail.com>
 <20111122195714.GA2815@xanatos>
 <CAJ54Ua4HgcDkWrcgVHNtNBmwgHh+Swn_Q2kKGLKS5+d94g07kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ54Ua4HgcDkWrcgVHNtNBmwgHh+Swn_Q2kKGLKS5+d94g07kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:20:10AM +0530, Aman Deep wrote:
> Hi Sarah,
> 
> 
> > >
> > > Also use some #defines in places where magic numbers are being used.
> >
> > Looks fine to me for the xHCI changes.  I copied most of the hub
> > descriptor code from EHCI, so it will need the same treatment.
> 
> Okay, thanks. I will try to make some of these changes into other host
> controller drivers also as
> soon as I can.
> 
> >
> > Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> 
> Thanks for the ACK, Sarah.
> 
> >
> > The #defines look a bit odd to me, like you're using spaces instead of
> > tabs to separate the name and value, or your mail program is converting
> > tabs to spaces.  Do the numbers line up for you?
> 
> Actually, both the HUB_CHAR_TTTT and HUB_CHAR_PORTIND were already using
> spaces instead of tabs. I just copied them to the lines below, thats
> why they still have
> spaces between define and value.
> 
> But thanks for info. I will take more care about this in future.
> 
> Do you want me to make any changes in this patch ?

Fixing them up to have tabs instead of spaces would be nice, but is not
required. :)

Sarah Sharp
