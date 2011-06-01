Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab1FAKUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:20:52 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:55836 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756998Ab1FAKUu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:20:50 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: Stefan Metzmacher <metze@samba.org>, Oliver Neukum <oliver@neukum.name>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 1 Jun 2011 12:20:20 +0200
Subject: RE: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Topic: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Index: AcwgQ/G6oYxCJQySRzmB1Tmegqrs1QAAGNsw
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
References: <1306922913-17803-1-git-send-email-metze@samba.org>
 <1306922913-17803-2-git-send-email-metze@samba.org>
In-Reply-To: <1306922913-17803-2-git-send-email-metze@samba.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Stefan Metzmacher
> Sent: Wednesday, June 01, 2011 12:09 PM


> -	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET,
> +	.flags = FLAG_WWAN | FLAG_NO_SETINT | FLAG_MULTI_PACKET,

This patch will introduce incompatibility with already existing
applications, which track usbX devices. As a result, end user
application will stop working.

cdc_ncm driver can also be used for local link terminated in device,
so wwan would be inappropriate name.

Regards,
Alexey


