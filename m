Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1HBOlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:41:45 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:51220 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab1HBOli convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:41:38 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Date: Tue, 2 Aug 2011 16:08:47 +0200
Subject: RE: [PATCH v2] usbnet/cdc_ncm: Don't use stack variables for DMA
 buffers
Thread-Topic: [PATCH v2] usbnet/cdc_ncm: Don't use stack variables for DMA
 buffers
Thread-Index: AcxRDgY0iysvOyuPSde0zhs+zz7TZwADwWZg
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3DEF674A@EXDCVYMBSTM006.EQ1STM.local>
References: <20110802121628.GF2096@zod.bos.redhat.com>
In-Reply-To: <20110802121628.GF2096@zod.bos.redhat.com>
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
> From: Josh Boyer [mailto:jwboyer@redhat.com]
> Sent: Tuesday, August 02, 2011 2:16 PM
> To: Oliver Neukum
> Cc: Alexey ORISHKO; Greg Kroah-Hartman; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v2] usbnet/cdc_ncm: Don't use stack variables for DMA buffers
> 

patch has style problems, please run checkpatch script

/alexey
