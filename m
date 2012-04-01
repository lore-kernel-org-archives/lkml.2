Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2DARLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:11:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44781 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2DARK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:10:57 -0400
Date: Sun, 1 Apr 2012 10:10:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120401171053.GA24779@kroah.com>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways>
 <20120401161108.GA6448@milliways>
 <CA+55aFzEgpfBvFmxQnvaD0RY5q2ST1G_ue=u0Gpbxeptc4+TNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzEgpfBvFmxQnvaD0RY5q2ST1G_ue=u0Gpbxeptc4+TNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 09:59:12AM -0700, Linus Torvalds wrote:
> On Sun, Apr 1, 2012 at 9:11 AM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> >
> >  BUT, for 3.4.0-rc1 I don't need to revert it - just went with the
> > defaults for additions in menuconfig, and it boots fine.  Maybe
> > something else needs to be backported ?
> 
> It was fixed by commit c9651e70ad0a ("ASPM: Fix pcie devices with
> non-pcie children") which is marked for stable but just hasn't made it
> quite yet.

I've added it now, it will show up in the next round of stable kernels.

greg k-h
