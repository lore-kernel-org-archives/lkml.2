Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab0DHUc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:32:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41147 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582Ab0DHUcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:32:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: 2.6.33.2 circular locking, hibernate, dm-crypt
Date: Thu, 8 Apr 2010 22:35:25 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: dm-crypt@saout.de, pm-utils@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
References: <20100408110607.GB1788@linux-m68k.org>
In-Reply-To: <20100408110607.GB1788@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082235.25263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Richard Zidlicky wrote:
> Hi,
> 
> this might be a regression - have not seen this warning in 2.6.32 with identical
> hardware. Btw the ageold usb-sound issue still appears present in 2.6.33.2, do not
> think it is related but I mention it because it also frequently causes circular
> locking warnings on my hardware.

Can you please check if this also is present in the latest 2.6.34-rc kernels
(preferably 2.6.34-rc4 when it's out)?

Rafael
