Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1CNWXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:23:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59982
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab1CNWXv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:23:51 -0400
Date: Mon, 14 Mar 2011 15:24:29 -0700 (PDT)
Message-Id: <20110314.152429.191392418.davem@davemloft.net>
To: remi.denis-courmont@nokia.com
Cc: jslaby@suse.cz, jirislaby@gmail.com, netdev@vger.kernel.org,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: cdc-phonet, handle empty phonet header
From: David Miller <davem@davemloft.net>
In-Reply-To: <201103140949.04760.remi.denis-courmont@nokia.com>
References: <1300035271-8138-1-git-send-email-jslaby@suse.cz>
	<1300035271-8138-2-git-send-email-jslaby@suse.cz>
	<201103140949.04760.remi.denis-courmont@nokia.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rémi Denis-Courmont" <remi.denis-courmont@nokia.com>
Date: Mon, 14 Mar 2011 09:49:04 +0200

> On Sunday 13 March 2011 18:54:31 ext Jiri Slaby, you wrote:
>> Currently, for N 5800 XM I get:
>> cdc_phonet: probe of 1-6:1.10 failed with error -22
>> 
>> It's because phonet_header is empty. Extra altsetting looks like
>> there:
>> E 05 24 00 01 10 03 24 ab 05 24 06 0a 0b 04 24 fd  .$....$..$....$.
>> E 00                                               .
>> 
>> I don't see the header used anywhere so just check if the phonet
>> descriptor is there, not the structure itself.
>> 
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
>> Cc: David S. Miller <davem@davemloft.net>
> 
> Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

Also applied, thanks.
