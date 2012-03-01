Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab2CAMeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:34:05 -0500
Received: from mx0.aculab.com ([213.249.233.131]:42371 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759112Ab2CAMeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:34:03 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX
Date: Thu, 1 Mar 2012 12:33:14 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E86@saturn3.aculab.com>
In-Reply-To: <1330604802.2465.43.camel@edumazet-laptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX
Thread-Index: Acz3pruiey8oJ/8WQ061ZRrQWTBZEAAAFkGA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>
Cc: "David Miller" <davem@davemloft.net>, <rodrigo.moya@collabora.co.uk>,
        <javier@collabora.co.uk>, <lennart@poettering.net>,
        <kay.sievers@vrfy.org>, <alban.crequy@collabora.co.uk>,
        <bart.cerneels@collabora.co.uk>, <sjoerd.simons@collabora.co.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Mar 2012 12:33:14.0509 (UTC) FILETIME=[78CB4BD0:01CCF7A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > So, now we are trying a different approach. To create a new address
> > family AF_MCAST. That way we can have more control over the
semantics of
> > the socket interface for that family.
> > 
> > We expect to have some patches in a few days and we will resend.
> > 
> > Does this makes more sense to you?
> > 
> 
> Why adding an obscure set of IPC mechanism in network tree, and not
> using (maybe extending) traditional IPC (Messages queues, semaphores,
> Shared memory, pipes, futexes, ...).

If it isn't a totally silly suggestion, why not write a simple
device driver that just does what you want?
Which (I think) is named pipes with multiple readers.

	David


