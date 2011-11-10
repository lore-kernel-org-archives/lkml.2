Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1KJDTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:19:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1KJDTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:19:37 -0500
Date: Wed, 9 Nov 2011 19:15:24 -0800
From: Greg KH <gregkh@suse.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/262] 3.0.9-stable review
Message-ID: <20111110031524.GA22180@suse.de>
References: <20111109212847.GA20838@kroah.com>
 <20111110005406.GA22026@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110005406.GA22026@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 02:54:07AM +0200, Kirill A. Shutemov wrote:
> On Wed, Nov 09, 2011 at 01:28:47PM -0800, Greg KH wrote:
> > This is the start of the stable review cycle for the 3.0.9 release.
> 
> Could you include these two:
> 
> a94cc4e sfi: table irq 0xFF means 'no interrupt'

Why was this not marked for stable?

> 153b19a x86, mrst: use a temporary variable for SFI irq

Odd, I wonder how I missed this one.

Anyway, I'll queue these up for the next 3.0 release after this one if
you don't mind.

thanks,

greg k-h
