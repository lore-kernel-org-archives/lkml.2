Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab2JUQbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:31:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51688 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab2JUQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:31:13 -0400
Date: Sun, 21 Oct 2012 09:31:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heinz Diehl <htd@fritha.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>, Ben Skeggs <bskeggs@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 60/76] drm/nouveau/bios: fix shadowing of ACPI ROMs larger
 than 64KiB
Message-ID: <20121021163135.GA27797@kroah.com>
References: <20121019024350.087156547@linuxfoundation.org>
 <20121019024359.774396402@linuxfoundation.org>
 <20121019160103.GA1570@fritha.org>
 <20121019174807.GA3017@kroah.com>
 <20121019191115.GA1635@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019191115.GA1635@fritha.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 09:11:15PM +0200, Heinz Diehl wrote:
> On 19.10.2012, Greg Kroah-Hartman wrote: 
> 
> > Does Linus's 3.7 git tree also crash for you this way?
> 
> Yes, it crashes in the same way with latest linus git 3.7.
> Here's the screenshot:
> 
> http://www.fritha.org/crash-linus-git.jpg

Ok, I've dropped it from the 3.6-stable release.  Ben, when you all have
a fix for this in Linus's tree, feel free to send me the two git commit
ids and I'll queue them up.

thanks,

greg k-h
