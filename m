Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0F2HMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:12:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43150
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700Ab0F2HMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:12:03 -0400
Date: Tue, 29 Jun 2010 00:12:16 -0700 (PDT)
Message-Id: <20100629.001216.91341775.davem@davemloft.net>
To: ospite@studenti.unina.it
Cc: alan@signal11.us, marcel@holtmann.org, jkosina@suse.cz,
       mdpoole@troilus.org, hadess@hadess.net, eric.dumazet@gmail.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Bluetooth: hidp: Add support for hidraw
 HIDIOCGFEATURE and HIDIOCSFEATURE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100628131437.bde782b6.ospite@studenti.unina.it>
References: <1276467601-9066-1-git-send-email-alan@signal11.us>
	<20100628131437.bde782b6.ospite@studenti.unina.it>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Ospite <ospite@studenti.unina.it>
Date: Mon, 28 Jun 2010 13:14:37 +0200

> On Sun, 13 Jun 2010 18:20:01 -0400
> Alan Ott <alan@signal11.us> wrote:
> 
>> This patch adds support or getting and setting feature reports for bluetooth
>> HID devices from HIDRAW.
>> 
>> Signed-off-by: Alan Ott <alan@signal11.us>
>> ---
> 
> Ping.

We effectively don't have a bluetooth maintainer at the current point
in time.  I've tried to let patches sit for a while hoping the listed
maintainer would do something, at least occaisionally, but that simply
isn't happening.

So I'll just pick patches up directly as I find time to review them,
but I have to warn that for me it's going to be done in a very low
priority way because I really don't find bluetooth all that exciting. :-)

