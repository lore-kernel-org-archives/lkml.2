Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2JKACT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:02:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:63515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2JKACR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="204112773"
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: David Howells <dhowells@redhat.com>
CC: linux-wimax <linux-wimax@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [GIT PULL] Disintegrate UAPI for wimax
Thread-Topic: [GIT PULL] Disintegrate UAPI for wimax
Thread-Index: AQHNpiJXLQNKsYximkG7w9QXVvFJhJezOpzg
Date: Thu, 11 Oct 2012 00:02:16 +0000
Message-ID: <3A78FAA0EC814D4B8ECC99B3AB32B33208612DA4@fmsmsx110.amr.corp.intel.com>
References: <30770.1349789450@warthog.procyon.org.uk>
In-Reply-To: <30770.1349789450@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David

> From: David Howells [mailto:dhowells@redhat.com]
> 
> Can you merge the following branch into the wimax tree please.
> 
> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches,
> userspace headers will be segregated into:
> 
> 	include/uapi/linux/.../foo.h
> 
> for the userspace interface stuff, and:
> 
> 	include/linux/.../foo.h
> 
> for the strictly kernel internal stuff.

This can be submitted straight to Dave Miller, as there is no separate wimax tree
anymore, it is in pure maintenance mode.

BTW: thanks for tackling the UAPI issue

Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
