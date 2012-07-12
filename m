Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab2GLJLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:11:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46374 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab2GLJLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120712083610.GE6056@mwanda>
References: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
	<20120712083610.GE6056@mwanda>
Date: Thu, 12 Jul 2012 14:56:16 +0545
Message-ID: <CAHdPZaOBdSaS622rAKJ4wEZMYne8-4fvcVDYPKHqBkp3vXzR2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging/et131x: remove memset for the TCB
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 2:21 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Jul 12, 2012 at 11:54:28AM +0545, Devendra Naga wrote:
>> TCB has kcalloc' ed so no need to call memset again on it.
>>
>
> Gar...  What about when this is called from et131x_adjust_link() and
> et1310_disable_phy_coma()?
>
Yeah, i didn't looked those paths, i am sorry.
> Really this changelog is annoying.  Based on the changelog I was
> expecting the kcalloc() to be in the same function but it wasn't.
> So then I have to redo all your work and check every code path.  You
> could have said what the code paths were in your description so I
> don't have to grovel through it all myself.
>
Ok. will try to put all the info i found while sending patches from next time
> regards,
> dan carpenter
>
>

Thanks,
Devendra.
