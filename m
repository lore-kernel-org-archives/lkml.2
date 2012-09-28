Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab2I1VYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:24:30 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10342 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964963Ab2I1U3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,503,1344236400"; 
   d="scan'208";a="695358889"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dick Streefland <dick.streefland@altium.nl>
Subject: Re: [ 070/218] SUNRPC: Fix a UDP transport regression
Thread-Topic: [ 070/218] SUNRPC: Fix a UDP transport regression
Thread-Index: AQHNnbddGh1NIDpKcE2ye9YPNHTip5egqeAA
Date: Fri, 28 Sep 2012 20:29:37 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FF45E6@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120928201501.208384923@linuxfoundation.org>
	 <20120928201509.596735923@linuxfoundation.org>
In-Reply-To: <20120928201509.596735923@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D2424631D554846BC82688B647E92DD@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8SLOlJ9017016

On Fri, 2012-09-28 at 13:14 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> commit f39c1bfb5a03e2d255451bff05be0d7255298fa4 upstream.
> 
> Commit 43cedbf0e8dfb9c5610eb7985d5f21263e313802 (SUNRPC: Ensure that
> we grab the XPRT_LOCK before calling xprt_alloc_slot) is causing
> hangs in the case of NFS over UDP mounts.

Ditto with this. Please hold this patch until the 1 line fix mentioned
previously has been merged upstream (at which point I will resend the
patch through stable@vger.kernel.org).

Thanks!
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
