Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0K3RsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:48:14 -0500
Received: from kroah.org ([198.145.64.141]:45734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0K3RsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:48:12 -0500
Date: Tue, 30 Nov 2010 09:40:52 -0800
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: erazor_de@users.sourceforge.net, Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] HID: roccat: declaring meaning of pack pragma
 usage in driver headers
Message-ID: <20101130174052.GA19977@kroah.com>
References: <1290801456.18750.164.camel@neuromancer>
 <1290804616.3051.52.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290804616.3051.52.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 08:50:16PM +0000, Ben Hutchings wrote:
> On Fri, 2010-11-26 at 20:57 +0100, Stefan Achatz wrote:
> > Using pack pragma to prevent padding bytes in binary data structures
> > used for hardware communication. Explanation of these pragmas was requested.
> [...]
> 
> It would be clearer to use the '__packed' macro after each structure
> definition instead of using this awful Microsoft extension.

I agree, that's the "normal" Linux way of doing things.

Other than that, this patch set looks good to me.  Jiri, if the packed
change is made, do you want me to take these through my tree, or do you
want to take them through yours?  Whatever is easier for you is fine
with me.

thanks,

greg k-h
