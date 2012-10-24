Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab2JXU0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:26:47 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:53114 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab2JXU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:26:45 -0400
Date: Wed, 24 Oct 2012 22:05:25 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] r8169: enable ALDPS for power saving
Message-ID: <20121024200525.GB6347@electric-eye.fr.zoreil.com>
References: <1350893153-18320-1-git-send-email-hayeswang@realtek.com> <20121022192748.GA16370@electric-eye.fr.zoreil.com> <D81B36B929404E28AE7007B7E21B9D46@realtek.com.tw> <20121023193146.GA10463@electric-eye.fr.zoreil.com> <B3B61E0990514F28A8203537EB9D047A@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B3B61E0990514F28A8203537EB9D047A@realtek.com.tw>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
>  Francois Romieu [mailto:romieu@fr.zoreil.com] 
> [...]
> > It would be nice to state these things in the commit message, namely:
> > - ALDPS should never be enabled for the RTL8105e
> > - none of the firmware-free chipsets support ALDPS
> > - neither do the RTL8168d/8111d
> 
> Excuse me. I don't understand why the RTL8105e shouldn't enable ALDPS.

I'd appreciate to see such a statement if ALDPS can be enabled with the
RTL8105e !

You have sent ALDPS related patches for some specific chipsets. Now
would be a sensible time to check if ALDPS is correctly handled for
_all_ supported chipsets. I don't have access to your authoritative
resources. I can only outline something strange in the code wrt
ALDPS and the 8105e.

/me returns to 8169b RxOverflow oddities...

-- 
Ueimor
