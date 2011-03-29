Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1C2NXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:23:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1C2NXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:23:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Tue, 29 Mar 2011 15:22:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Waldemar.Rymarkiewicz@tieto.com, sameo@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103291404.39023.arnd@arndb.de> <20110329132305.7aa065a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110329132305.7aa065a1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291522.56667.arnd@arndb.de>
X-Provags-ID: V02:K0:BR4p4WxNRCbc70MBOf+jb4jVyxIiffXenIl4+snjzXg
 /I4Qq1eOHANrJEd75btsOOpgON76IGddhPjA4aome5QNCwV3Aj
 bVxL5KDdpjxtc7s2LZ/oQtqbCZIAnN4NbSVSj7C9lIoDd3yMlg
 b667LTj64izNEC7eMvQ3MFE2PxvRtrEpscHqr4CeGszTtf3fKT
 ESH/azIo5HwV3MxHgPuFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Alan Cox wrote:
> > I was under the impression that NFC was peer-to-peer, so the driver
> > would already be handling both sides potentially.
> 
> Your security requirements each side are going to be very different. A
> phone or handheld device is generally single user at a time, the other
> end may well be interacting with many devices at once each with their own
> security context and potentially handling sensitive data (payment
> authorisations for example).

Yes, good point.

	Arnd
