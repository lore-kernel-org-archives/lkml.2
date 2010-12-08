Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0LHPGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:06:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab0LHPGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:06:44 -0500
Date: Wed, 8 Dec 2010 07:06:42 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] sysfs: Introducing binary attributes for struct
 class
Message-ID: <20101208150642.GA5669@suse.de>
References: <1290801449.18750.162.camel@neuromancer>
 <alpine.LNX.2.00.1012081432230.14806@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012081432230.14806@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 02:33:14PM +0100, Jiri Kosina wrote:
> On Fri, 26 Nov 2010, Stefan Achatz wrote:
> 
> > Added dev_bin_attrs to struct class similar to existing dev_attrs.
> > 
> > Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> 
> Greg, just to make sure (as you have stated your Ack in a thread belonging 
> to different thread) -- I can add your Acked-by: to this patch and take it 
> through my tree with the rest of the roccat patchset, is that correct?

Yes you can.

thanks,

greg k-h
