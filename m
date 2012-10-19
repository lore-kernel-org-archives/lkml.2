Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2JSRsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:48:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2JSRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:48:11 -0400
Date: Fri, 19 Oct 2012 10:48:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heinz Diehl <htd@fancy-poultry.org>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [ 60/76] drm/nouveau/bios: fix shadowing of ACPI ROMs larger
 than 64KiB
Message-ID: <20121019174807.GA3017@kroah.com>
References: <20121019024350.087156547@linuxfoundation.org>
 <20121019024359.774396402@linuxfoundation.org>
 <20121019160103.GA1570@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019160103.GA1570@fritha.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 06:01:03PM +0200, Heinz Diehl wrote:
> On 19.10.2012, Greg Kroah-Hartman wrote: 
> 
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> 
> While 3.6.2 is fine. 3.6.3-rc1 crashes my machine (Asus U45-JC) at
> boot. A screenshot of the output is here:
> 
> http://www.fritha.org/crash.jpg
> 
> Reverting this one fixes it:
> 
> > Ben Skeggs <bskeggs@redhat.com>
> >     drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB

Ick.

Does Linus's 3.7 git tree also crash for you this way?

Ben, any thoughts?  Should I just drop this for now from the 3.6-stable
tree until it gets worked out?

greg k-h
