Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2GBJWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:22:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33757 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab2GBJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:22:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FF16773.3030202@mev.co.uk>
References: <1341159624-23968-1-git-send-email-devendra.aaru@gmail.com>
	<4FF15FAB.9050905@mev.co.uk>
	<CAHdPZaP5MgPqzK2RLfUTHkxOHKnGkEJLX6pA-pOVWp=Ri4A8-w@mail.gmail.com>
	<4FF16773.3030202@mev.co.uk>
Date: Mon, 2 Jul 2012 14:52:05 +0530
Message-ID: <CAHdPZaMrYbpZNGziZJf3oPH0WemFKvrT+Me1goEKeEOWhDkmNQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] staging/comedi/drivers: free allocated priv and
 release resources if comedi_alloc_subdevices
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 2:48 PM, Ian Abbott <abbotti@mev.co.uk> wrote:
> On 2012-07-02 09:51, devendra.aaru wrote:
>>
>> anyway i have a question
>>
>> are you going to remove the alloc_private wapper and use kzalloc?
>
>
> I'm not averse to the idea, but it's not a high priority.
>

Then will i do? and change all drivers?
I dunno about any other guys doing it ...
>
> --
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
>
>

Thanks,
Devendra.
