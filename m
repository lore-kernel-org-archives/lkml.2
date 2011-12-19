Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1LSMZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:25:54 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43648 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab1LSMZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:25:52 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1324295757.3350.3.camel@phoenix>
References: <1324295757.3350.3.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 19 Dec 2011 20:25:27 +0800
Message-ID: <CAF+7xWmHa1ef2nd0g7Gf+rjsxUemapSLK_uwHxYnNws2dy9h_w@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] mfd: Fix checking bit_mask for adp5520_set_bits
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/19 Axel Lin <axel.lin@gmail.com>:
> Current code checks if all the bit_mask bits are all zero is wrong.
> We need to write new value if old value is not equal to new value.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
> Hi Samuel,
> I found this serial of patches are not merged yet.
> ( although you replied that you applied all 3 patches in the mail )
> It was post on https://lkml.org/lkml/2011/10/30/137
> So I resend it again.
>
Hi Samuel,
I found these patches already in your for-linus branch.
But it is strange that these patches are not exist in linux-next tree.

Regards,
Axel
