Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab1CNHtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 03:49:07 -0400
Received: from smtp.nokia.com ([147.243.128.26]:57977 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1CNHtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 03:49:06 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" 
	<remi.denis-courmont@nokia.com>
Organization: MeeGo Devices - Nokia
To: ext Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/2] NET: cdc-phonet, handle empty phonet header
Date: Mon, 14 Mar 2011 09:49:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-27-generic; KDE/4.5.1; i686; ; )
Cc: davem@davemloft.net, jirislaby@gmail.com, netdev@vger.kernel.org,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1300035271-8138-1-git-send-email-jslaby@suse.cz> <1300035271-8138-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1300035271-8138-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103140949.04760.remi.denis-courmont@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 March 2011 18:54:31 ext Jiri Slaby, you wrote:
> Currently, for N 5800 XM I get:
> cdc_phonet: probe of 1-6:1.10 failed with error -22
> 
> It's because phonet_header is empty. Extra altsetting looks like
> there:
> E 05 24 00 01 10 03 24 ab 05 24 06 0a 0b 04 24 fd  .$....$..$....$.
> E 00                                               .
> 
> I don't see the header used anywhere so just check if the phonet
> descriptor is there, not the structure itself.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
> Cc: David S. Miller <davem@davemloft.net>

Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

-- 
Rémi Denis-Courmont
http://www.remlab.net/
