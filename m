Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab2BIOwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:52:54 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:34462 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2BIOwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:52:53 -0500
From: Oliver Neukum <oliver@neukum.org>
To: =?utf-8?q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 37/50] usbnet: set addr_assign_type if random_ether_addr() used
Date: Thu, 9 Feb 2012 15:55:14 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Danny Kukawka <danny.kukawka@bisect.de>, Danny Kukawka <dkukawka@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <201202082230.19936.oliver@neukum.org> <874nv07au1.fsf@nemi.mork.no>
In-Reply-To: <874nv07au1.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202091555.15071.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 9. Februar 2012, 07:57:42 schrieb Bjørn Mork:
> > Don't you set the flag too early here? By that time we don't know
> > whether the device provides a real MAC, do we?
> 
> Maybe it makes sense to set it here anyway since usbnet provides this
> default random address, and let the minidrivers which set a real mac
> also clear the flag?  But in that case the patch need to clear the flag
> everywhere a minidriver currently updates the address.
> 

Doable, but where is the benefit? It seems better to me to make an effort
to guess as well as possible in the common code.

	Regards
		Oliver
