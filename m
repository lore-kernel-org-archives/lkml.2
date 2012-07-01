Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2GAQGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:06:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54595 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2GAQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120701153218.GB4462@mwanda>
References: <1341150127-13162-1-git-send-email-devendra.aaru@gmail.com>
	<20120701153218.GB4462@mwanda>
Date: Sun, 1 Jul 2012 21:36:19 +0530
Message-ID: <CAHdPZaO-BPVCaiWbaE7k3o+7vRx040fvR4AyGyBMsfnchv_jVA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] staging/comedi/drivers: free allocated priv and
 release resources if comedi_alloc_subdevices
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Sun, Jul 1, 2012 at 9:02 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sun, Jul 01, 2012 at 07:12:07PM +0530, Devendra Naga wrote:
>> as comedi_alloc_subdevices may fail, we leak out the memory allocated by alloc_private,
>> and also the I/O regions we requested.
>>
>> free out the private data pointer of the driver, and release the I/O regions.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>
> This breaks the build.

dev->priv should be dev->private. I was in a hurry to send the fix and
didn't build tested,
>
> Also Hartley and Ian, what's the point of alloc_private()?  It's
> just hiding stuff which we need to know about and use later on
> anyway.
>
> regards,
> dan carpenter
>
>

sorry again,

Devendra.
