Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1AFSWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:22:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:2929 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AFSWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:22:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,284,1291622400"; 
   d="scan'208";a="371045088"
From: "Luck, Tony" <tony.luck@intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Date: Thu, 6 Jan 2011 10:22:42 -0800
Subject: RE: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
Thread-Topic: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
Thread-Index: Acutw6kiJH0fa9mQR/ae+GLZ66yQswACnT9A
Message-ID: <987664A83D2D224EAE907B061CE93D530193FC6AA2@orsmsx505.amr.corp.intel.com>
References: <4D25AEEE.1050401@gmail.com> <1294322613.2016.333.camel@laptop>
 <4D25ED22.3070900@gmail.com> <4D25F4CF.1030009@gmail.com>
In-Reply-To: <4D25F4CF.1030009@gmail.com>
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

> Errata corrige: maybe I used the wrong term, I meant "volatile" instead
> of "temporary" information, i.e. I'd like to save this info to re-read
> it later but I don't want to store it in flash, a simple log, run-time
> information for debug like a flight-recorder or whatever you want.

I'm puzzled by the use of "a generic piece of memory" to store "persistent"
things (Perhaps this is made clear in the 17 parts of the patch? I haven't
read them yet).  On x86 f/w typically clears all of memory on reset ... so
you only get persistence if you use kexec to get from the old kernel to
the new one.

-Tony
