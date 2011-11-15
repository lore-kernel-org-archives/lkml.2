Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1KOPUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:20:04 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:38419 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695Ab1KOPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:20:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBANyBwk4Y9geI/2dsb2JhbAAMOIUBp2QBAQEBAyNVARALDgYBAwICBRYLAgIJAwIBAgFFBg0BBQIBAa5okhyBMIdLgRYEiBOeNw
X-IronPort-AV: E=Sophos;i="4.69,515,1315195200"; 
   d="scan'208";a="148054145"
Message-ID: <4EC2831F.9070907@teksavvy.com>
Date: Tue, 15 Nov 2011 10:19:59 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grundler@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw
Subject: Re: [PATCH 5/5] net-next:asix: update VERSION and white space changes
References: <CANEJEGuzdxDuVysuAJPcdC7-mywa8B8JggVHe_VMTK_1j4QguQ@mail.gmail.com> <20111114.213255.2061756136146824209.davem@davemloft.net> <20111114.214151.1988775203701808195.davem@davemloft.net> <20111114.214542.1423779515286773837.davem@davemloft.net>
In-Reply-To: <20111114.214542.1423779515286773837.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-14 09:45 PM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 14 Nov 2011 21:41:51 -0500 (EST)
> 
>> Come on man... are you kidding me?
> 
> Want to know what really pisses me off about this?
> 
> All of Mark Lord's hard work to bring the entire vendor driver over
> was thrown out.


Well, ASIX and I appear to be back on track again.

So once the dust settles in net-dev with Grant's patches,
I will take over development of the asix driver,
and start sending you (Dave) patches to merge the
rest of the vendor's driver code.

With luck, it might all make it in there in time for the next (3.3) merge.

Cheers
