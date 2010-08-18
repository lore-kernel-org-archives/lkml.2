Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0HRUKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:10:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51824 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0HRUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wjUV28TQugOFYpki+8IeOc+n2ZiM848Nfj4zKJiXP0j+nxOerxsRQx3akSpPGeFJX7
         o70nluMYf+AzPgf8iFBSw5lfItdGS6U+L2ioSCa0Tblom0M+dZpcP7AVzgL0Q56G917/
         hZnJ5bPbLiyGkpvS1v260w/OPp0m9mPvL5WXY=
Date: Wed, 18 Aug 2010 22:00:57 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.2 regression, does not boot, sleeping function called
	from invalid context
Message-ID: <20100818200057.GA4132@linux-m68k.org>
References: <20100817145305.GA7342@linux-m68k.org> <20100818133459.GA6663@kroah.com> <20100818140335.GB18303@linux-m68k.org> <20100818143927.GA1202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818143927.GA1202@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 07:39:27AM -0700, Greg KH wrote:
> On Wed, Aug 18, 2010 at 04:03:35PM +0200, Richard Zidlicky wrote:
> > On Wed, Aug 18, 2010 at 06:34:59AM -0700, Greg KH wrote:

> 
> Yes, they are in Linus's tree, commits:
> 	d7824370e26325c881b665350ce64fb0a4fde24a
> and
> 	11ac552477e32835cb6970bf0a70c210807f5673

great, that works. 

Unfortunately no improvemenet with the hibernation problem that is there since
2.6.35?

Richard
