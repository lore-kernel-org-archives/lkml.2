Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2CDTqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:46:42 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43624 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab2CDTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:46:40 -0500
X-Sasl-enc: p7MPZBBKu4q7ddUqA8pC8/HYngP7nyoqBXWNfM1D9n4J 1330890399
Message-ID: <4F53C694.5060308@signal11.us>
Date: Sun, 04 Mar 2012 14:46:28 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 5/6] ARM: tegra: USB_ULPI needs USB
References: <1330721919-8800-1-git-send-email-alan@signal11.us> <20120304184015.GE31064@quad.lixom.net>
In-Reply-To: <20120304184015.GE31064@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/12 1:40 PM, Olof Johansson wrote:
> On Fri, Mar 02, 2012 at 03:58:39PM -0500, Alan Ott wrote:
>> From: Arnd Bergmann<arnd@arndb.de>
>>
>> The USB_ULPI driver is selected by tegra, but can only be
>> built if at least one of USB or USB_GADGET is enabled.
>> The kernel fails to link if both are off.
>>
>> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
>> Signed-off-by: Alan Ott<alan@signal11.us>
>> ---
> This is another patch that needs the same change for T30.
>
>
> -Olof

It is in v3. It looks like you took (or at least replied to) v2 for all 
these.

Alan.
