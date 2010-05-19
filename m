Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0ESSUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:20:22 -0400
Received: from kroah.org ([198.145.64.141]:37759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0ESSUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:20:21 -0400
Date: Wed, 19 May 2010 11:19:26 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>, hjanssen@microsoft.com,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/2] Hyperv detection - code cleanup
Message-ID: <20100519181926.GA22228@kroah.com>
References: <4BF3C97F020000300008560D@sinclair.provo.novell.com>
 <4BF424FE.80400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF424FE.80400@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:50:54AM -0700, H. Peter Anvin wrote:
> On 05/19/2010 10:20 AM, Ky Srinivasan wrote:
> > From: K. Y. Srinivasan <ksrinivasan@novell.com>
> > Subject: Code cleanup - get rid of the "ms" prefix in hyperv related files.  
> > 
> > 
> > Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
> 
> NAK in the extreme.
> 
> "hyperv" -- without the capitalization to make it stand out -- is way
> too easy to read as just an abbreviation for "hypervisor".

Which is what I confused it with, and hence I wrote the ms_* changes in
my patch.  But KY wanted it changed back so I suggested he write a
patch.

I personally like the ms_ stuff, it makes it more obvious what is going
on here, but that's just me.

thanks,

greg k-h
