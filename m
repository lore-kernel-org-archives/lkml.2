Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0EaUxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:53:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59859 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0EaUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:53:03 -0400
Date: Mon, 31 May 2010 14:53:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [Regression] [2.6.35-rc1] ssb_is_sprom_available
Message-ID: <20100531205300.GB32708@parisc-linux.org>
References: <201005312155.20602.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005312155.20602.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 09:55:20PM +0200, Maciej Rutecki wrote:
> Last known good: 2.6.34
> Failing kernel: 2.6.35-rc1
> 
> subsystem: PCI, USB(?)
> 
> Kernel dies during booting on message "ssb_is_sprom_available", see picture:
> http://www.unixy.pl/maciek/download/kernel/2.6.35-rc1/gumis/DSC_0011.JPG

Um, looks like it's something to do with the Sonics Silicon Backplane,
not PCI, nor USB.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
