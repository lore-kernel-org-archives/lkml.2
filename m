Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2DBJTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:19:25 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40323 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751497Ab2DBJTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:19:23 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [REGRESSION][PATCH V4 1/3] bpf jit: Make the filter.c::__load_pointer helper non-static  for the jits
Date: Mon, 2 Apr 2012 10:18:02 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6ECE@saturn3.aculab.com>
In-Reply-To: <4F75CC63.10405@googlemail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [REGRESSION][PATCH V4 1/3] bpf jit: Make the filter.c::__load_pointer helper non-static  for the jits
Thread-Index: Ac0OlZYv8RI9mkt6ROe8QEpOpjNLnQCG3/MQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Jan Seiffert" <kaffeemonster@googlemail.com>, <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Matt Evans" <matt@ozlabs.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 02 Apr 2012 09:18:02.0357 (UTC) FILETIME=[8106BA50:01CD10B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> The function is renamed to make it a little more clear what it does.
> It is not added to any .h because it is not for general 
> consumption, only for bpf internal use (and so by the jits).

I'd have thought it better to put in into a bfp_internal.h
(or similar) with a big warning there about the asm users.

Possibly even worth adding some other defs that the asm
files will need (if there are any).

	David


