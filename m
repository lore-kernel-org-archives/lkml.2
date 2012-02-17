Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2BQPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:48:14 -0500
Received: from mx0.aculab.com ([213.249.233.131]:45357 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751371Ab2BQPsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:48:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Cleaning up code formatting errors in net/wireless pointed out by checkpatch.
Date: Fri, 17 Feb 2012 15:47:36 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E75@saturn3.aculab.com>
In-Reply-To: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Cleaning up code formatting errors in net/wireless pointed out by checkpatch.
Thread-Index: AcztiURd6SkoJzg6Rd2OfskWe0nVLwAAV7hA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Luis Felipe Strano Moraes" <lfelipe@profusion.mobi>,
        <linville@tuxdriver.com>
Cc: <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Feb 2012 15:47:36.0919 (UTC) FILETIME=[78C31670:01CCED8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> These are mostly minor changes and they are being sent as one 
> patch only in order to cause the smallest amount of disruption.

A lot of these changes don't seem to match what I thought the
linux kernel code style is.

eg:
>  void cfg80211_bss_age(struct cfg80211_registered_device *dev,
> -                      unsigned long age_secs);
> +		      unsigned long age_secs);
Args no longer lined up.

> -		pos = (u8 *) & hdr->addr4;
> +		pos = (u8 *) &hdr->addr4;
no space after cast?

> -	p1 = (u8*)(ht_capa);
> +	p1 = (u8 *)(ht_capa);
Still extra ().

I'm also not sure (personally) this sort of churn is useful.

	David


