Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0DIT7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:59:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44775 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab0DIT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:59:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: 2.6.33.2 circular locking, hibernate, dm-crypt
Date: Fri, 9 Apr 2010 22:02:12 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: dm-crypt@saout.de, pm-utils@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
References: <20100408110607.GB1788@linux-m68k.org> <201004082235.25263.rjw@sisk.pl> <20100409100805.GA3468@linux-m68k.org>
In-Reply-To: <20100409100805.GA3468@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004092202.13037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010, Richard Zidlicky wrote:
> On Thu, Apr 08, 2010 at 10:35:25PM +0200, Rafael J. Wysocki wrote:
> 
> > Can you please check if this also is present in the latest 2.6.34-rc kernels
> > (preferably 2.6.34-rc4 when it's out)?
> 
> I can try it, or if you have a particular patch set try to apply it to 2.6.33. It is not
> 100% reproducible however.

Well, it's always a good idea to try the current Linus' tree.

Rafael
