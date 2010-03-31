Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0CaJhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:37:12 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39424 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035Ab0CaJhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PeFiFxSfw/LiD/CR+02vkCr+AtApU/ywXzIMMDKwz/tJ5chdX2Z+7qihSSrLTcXUvt
         1hccnMz6yY+LA+07STbTEXpUh0pvy+xXSTgRaA4+/Jr7ciEM8s8TXP4Pcs8JuzbhzmtL
         1ACVVPIXkfm0WTImH/hd3Dc8cxBNUmhSOrhgg=
MIME-Version: 1.0
In-Reply-To: <4BB3166C.70408@tudelft.nl>
References: <y2r40a4ed591003310218he411c263p62915a3e0a5a8de3@mail.gmail.com>
	 <4BB3166C.70408@tudelft.nl>
Date: Wed, 31 Mar 2010 11:37:07 +0200
Message-ID: <s2z40a4ed591003310237l6b4e85d4l99c97ae9602ea614@mail.gmail.com>
Subject: Re: 2.6.34-rc3 - nvidia: module license 'NVIDIA' taints kernel.
From: Zeno Davatz <zdavatz@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:31 AM, Éric Piel <E.A.B.Piel@tudelft.nl> wrote:
> On 31/03/10 11:18, Zeno Davatz wrote:
>> Ok, I just booted into the new 2.6.34-rc3 Kernel. Looks Lovely!
> :
>> resource map sanity check conflict: 0x9f800 0xa07ff 0xa0000 0xbffff
> :
>> Info: mapping multiple BARs. Your kernel is fine.
> :
>>
>> Can I ignore this or is this of any use for the list and the Kernel improvement?
> Hi,
> This is not tainting, it's a resource conflict. That check has just been
> added to the kernel, that's why it did not happen before. As mentioned
> in the log, your kernel is fine.
>
> As the conflict is happening with the proprietary driver, the only
> action you can do is to contact NVidia. Maybe they'll fix it in a later
> version...

Thank you for the quick response! Shall I contact any person that I
find at Nvidia or do you have a specific person that you recommend?

If you do not reply I will, just try to find a person at Nvidia.

Best
Zeno
