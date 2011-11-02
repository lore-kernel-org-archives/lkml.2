Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1KBWoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:44:23 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:65275 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751079Ab1KBWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:44:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAI/HsU4Y9geI/2dsb2JhbAAMOIR4ommFDQEBAQEDI1UBEAsODAIFFgsCAgkDAgECAUUGDQEHAQGqeZI1gTCGTIEUBKYV
X-IronPort-AV: E=Sophos;i="4.69,446,1315195200"; 
   d="scan'208";a="145988440"
Message-ID: <4EB1C7BC.1040801@teksavvy.com>
Date: Wed, 02 Nov 2011 18:44:12 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com>  <20111026.194045.2019668159403582571.davem@davemloft.net>  <4EA8B283.3010105@teksavvy.com>  <20111026.221719.2216112919297458522.davem@davemloft.net>  <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
In-Reply-To: <1320266549.2782.21.camel@bwh-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-02 04:42 PM, Ben Hutchings wrote:
[various good notes on things that still need fixing]

Thanks Ben, those are exactly the kind of things
I was hoping for people like you to point out here.

Also, I have now opened a line of communications with ASIX themselves,
and have their blessing for this project.  They've also now sent me
a newer code dump than the one I was using.  I'll diff the two and
add in any relevant changes for the next iteration.

Cheers
