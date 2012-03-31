Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab2CaOpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:45:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63900 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab2CaOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:45:36 -0400
Date: Sat, 31 Mar 2012 17:45:33 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Madore <david+ml@madore.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: since when does linkat() on deleted /proc/$PID/fd/$num return
 ENOENT ?
Message-ID: <20120331144533.GA4605@p183.telecom.by>
References: <20120330102121.GA5999@aldebaran.gro-tsen.net>
 <20120331065305.GA3398@p183.telecom.by>
 <20120331110640.GA18532@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331110640.GA18532@aldebaran.gro-tsen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 01:06:40PM +0200, David Madore wrote:
> On Sat, Mar 31, 2012 at 09:53:05AM +0300, Alexey Dobriyan wrote:
> > It was explicitly prohibited since 2.6.39:
> > 
> > commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date:   Sat Jan 29 18:43:27 2011 +0530
> > 
> >     fs: Don't allow to create hardlink for deleted file
> <snip>
> 
> Thanks for digging this for me!

Well, the question if this counts as userspace-visible change.
