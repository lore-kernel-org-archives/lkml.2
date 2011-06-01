Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161355Ab1FALkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:40:18 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:39797 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab1FALkN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:40:13 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 1 Jun 2011 13:39:57 +0200
Subject: RE: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Topic: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Index: AcwgSVLJIrfB/5moRuW50F+ki2f2VAAAcwsA
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E64B@EXDCVYMBSTM006.EQ1STM.local>
References: <1306922913-17803-1-git-send-email-metze@samba.org>
 <1306922913-17803-2-git-send-email-metze@samba.org>
 <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
 <4DE618B7.5070903@samba.org>
In-Reply-To: <4DE618B7.5070903@samba.org>
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
> From: Stefan (metze) Metzmacher [mailto:metze@samba.org]
> Sent: Wednesday, June 01, 2011 12:47 PM
> 
> Would it be possible to add some autodetection for known devices, in a
> similar way the cdc_ether driver does it.

If you use udev rules and create an alias for your device, you won't
be dependent on generic driver code.

Regards,
alexey
