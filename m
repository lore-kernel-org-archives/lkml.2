Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2JXFzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:55:44 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50970 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2JXFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:55:42 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q9O5tTId001663
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1350893153-18320-1-git-send-email-hayeswang@realtek.com> <20121022192748.GA16370@electric-eye.fr.zoreil.com> <D81B36B929404E28AE7007B7E21B9D46@realtek.com.tw> <20121023193146.GA10463@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 1/2] r8169: enable ALDPS for power saving
Date: Wed, 24 Oct 2012 13:55:28 +0800
Message-ID: <B3B61E0990514F28A8203537EB9D047A@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac2xWADifEii8XHqRQiLfRiwE9ttywAUxEEg
In-Reply-To: <20121023193146.GA10463@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> It would be nice to state these things in the commit message, namely:
> - ALDPS should never be enabled for the RTL8105e
> - none of the firmware-free chipsets support ALDPS
> - neither do the RTL8168d/8111d

Excuse me. I don't understand why the RTL8105e shouldn't enable ALDPS.
 
Best Regards,
Hayes

