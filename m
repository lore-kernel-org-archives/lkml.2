Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2BUTPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:15:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44903 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab2BUTPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:15:40 -0500
Message-ID: <4F43ED3D.20504@zytor.com>
Date: Tue, 21 Feb 2012 11:15:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/30] compat: Use COMPAT_USE_64BIT_TIME in the Bluetooth
 subsystem
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-11-git-send-email-hpa@zytor.com> <20120221190419.GA2914@joana>
In-Reply-To: <20120221190419.GA2914@joana>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 11:05 AM, Gustavo Padovan wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> [2012-02-19 16:07:48 -0800]:
> 
>> From: "H. J. Lu" <hjl.tools@gmail.com>
>>
>> Enable the Bluetooth subsystem to be used with a compat ABI with
>> 64-bit time.
>>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> Cc: Gustavo F. Padovan <padovan@profusion.mobi>
>> Cc: David S. Miller <davem@davemloft.net>
>> ---
>>  net/bluetooth/hci_sock.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> Applied, thanks.
> 

OK, I have it in my x86/x32 tree; you don't want to have this patch
without the prior patch for obvious reasons.

	-hpa


