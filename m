Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0HLRDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:03:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:59694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0HLRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:03:00 -0400
Date: Thu, 12 Aug 2010 10:02:38 -0700
From: Greg KH <gregkh@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Break the kobject namespace defs into their own header
Message-ID: <20100812170238.GC11701@suse.de>
References: <20100811150746.GA9070@suse.de>
 <20100811140102.19596.84876.stgit@warthog.procyon.org.uk>
 <12812.1281614185@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12812.1281614185@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:56:25PM +0100, David Howells wrote:
> 
> The compiler is:
> 
> 	gcc version 3.4-am33-04r2-5
> 
> which is a supported version according to the compiler-gcc3.h header file.

Ah, yeah, it's a gcc thing.  I'll queue this up.

thanks,

greg k-h
