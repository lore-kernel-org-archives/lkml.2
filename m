Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1CXR6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:58:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50342 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1CXR6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=-mGD670m9G31mYQjoj7Rt4_OveXOi2dTPYkxY@mail.gmail.com>
References: <AANLkTik20MfB5yta5mRoSny8NYOt3c0Rncg-rJY1SS9R@mail.gmail.com>
	<AANLkTi=-mGD670m9G31mYQjoj7Rt4_OveXOi2dTPYkxY@mail.gmail.com>
Date: Thu, 24 Mar 2011 14:58:49 -0300
X-Google-Sender-Auth: jVx-sDfglL1g5iOFEf-BQ02mioI
Message-ID: <AANLkTi=z0cAaCue=0F-ueiidwg_ctBPiYwyp35dQdjzo@mail.gmail.com>
Subject: Re: [PATCH 2.6.38] bluetooth: add support for Apple MacBook Pro 8,2
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Marc-Antoine Perennou <Marc-Antoine@perennou.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, stable@kernel.org,
        Travis Watkins <amaranth@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, Mar 24, 2011 at 1:10 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Mar 21, 2011 at 10:28 AM, Marc-Antoine Perennou
> <Marc-Antoine@perennou.com> wrote:
>> Just adding the vendor details makes it work fine.
>>
>> Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
>
> Acked by: Grant Likely <grant.likely@secretlab.ca>
>
> Marcel, this one is pretty trivial.  Can we get it picked up for
> 2.6.39?  It would also be useful to backport it to stable once it hits
> Linus' tree.

I applied this patch to the bluetooth tree and will send it mainline.
Thanks all.

-- 
Gustavo F. Padovan
http://profusion.mobi
