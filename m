Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2FGA7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:59:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:39023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab2FGA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:59:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149150224"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Ethan Zhao <ethan.kernel@gmail.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Linux NICS <linuxnics@mailbox.cps.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] [next-net PATCH]
 drivers/net/ethernet/intel/e1000e: fix unregistered net_device ethX name
 output by e1000e
Thread-Topic: [E1000-devel] [next-net PATCH]
 drivers/net/ethernet/intel/e1000e: fix unregistered net_device ethX name
 output by e1000e
Thread-Index: AQHNQ/UNhV81urQVqUyL+x3TZBGidJbueeaA//+Mg0A=
Date: Thu, 7 Jun 2012 00:56:34 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18428442D67@ORSMSX102.amr.corp.intel.com>
References: <CABawtvNv7LwT_awXscXGEid-1wes-+ZELc7YMLZqyo2h=h98UA@mail.gmail.com>
 <1339029671.10602.81.camel@jtkirshe-mobl>
In-Reply-To: <1339029671.10602.81.camel@jtkirshe-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q57104o9013989

> -----Original Message-----
> From: Jeff Kirsher [mailto:jeffrey.t.kirsher@intel.com]
> Sent: Wednesday, June 06, 2012 5:41 PM
> To: Ethan Zhao
> Cc: e1000-devel@lists.sourceforge.net; Linux NICS; LKML
> Subject: Re: [E1000-devel] [next-net PATCH]
> drivers/net/ethernet/intel/e1000e: fix unregistered net_device ethX
> name output by e1000e
> 
> On Wed, 2012-06-06 at 22:57 +0800, Ethan Zhao wrote:
> > commit ca3ccc6835943287b6f69e973c126a02bc4de409
> > Author: ethan.zhao <ethan.kernel@gmail.com>
> > Date:   Wed Jun 6 07:32:11 2012 -0700
> >
> >         modified:   drivers/net/ethernet/intel/e1000e/param.c
> >
> >     While e1000e_check_options() is called, netdev is not
> registered,
> > so the
> >     e1000e driver will print out confused ethernet interface name
> > (unregistered net_device) :
> >
> >     e1000e 0000:04:00.0:(unregistered net_device): Interrupt
> > Throttling Rate (ints/sec) set to dynamic conservative mode
> >
> >     So change e_info() back to dev_printk() by simply redefine the
> > e_info macro used by
> >     e1000e_check_options() and e1000_validate_option
> >
> >     after applied this patch, we got:
> >
> >     e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) set to
> > dynamic conservative mode
> >     e1000e 0000:04:00.0: irq 95 for MSI/MSI-X
> 
> NACK, I currently have a patch in my queue from Bruce Allan to resolve
> this issue.  I should be pushing the patch upstream in a few days.

For clarification, the problem with the NACK'ed patch is it is missing a
number of instances of the same issue that is meant to be addressed by the
patch.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
