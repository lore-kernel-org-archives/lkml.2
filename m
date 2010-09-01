Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0IAWIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:08:05 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:38629 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0IAWIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:08:04 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: Memory allocation modifications in ibm_newemac driver
Thread-Topic: Memory allocation modifications in ibm_newemac driver
Thread-Index: ActKFh1163SqUHTiROCjSFgwjSee2wABD/h2AAHTCpE=
Date: Wed, 1 Sep 2010 22:04:34 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>,<5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I think I have all the issues worked out and can now send and receive any size packet without a hiccup.  I have tested this in our system setup as well with data being sent out to disk and did not see any problems there either (since it only ever allocates a single page, never more).

Is this something that may be wanted in the mainline?  I have not run full benchmarks, but I anticipate that my modified driver is slightly slower than the mainline driver because we keep track of an SKB ring, as well as a ring of pages and allocate both on each packet received.

Thanks,

Jonathan

