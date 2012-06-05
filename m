Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2FEKX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:23:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39396 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2FEKXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120605035833.GA16700@kroah.com>
References: <1337520702-22961-1-git-send-email-devendra.aaru@gmail.com>
	<20120605035833.GA16700@kroah.com>
Date: Tue, 5 Jun 2012 15:53:25 +0530
Message-ID: <CAHdPZaNf2BL9pfYm-0-e9ij7UqpwmT_fYnex1fDr-Ce+3vjz=A@mail.gmail.com>
Subject: Re: [PATCH] staging/wlan-ng: Fix the checkpatch warnings
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for the review.

On Tue, Jun 5, 2012 at 9:28 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, May 20, 2012 at 07:01:42PM +0530, Devendra Naga wrote:
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> ---
>>  drivers/staging/wlan-ng/cfg80211.c |   27 +++++++++++++++++++--------
>>  1 file changed, 19 insertions(+), 8 deletions(-)
>
>
> Ok, you sent me 5 patches, all with the same subject (except for 3 of
> them you used x/3, which was nice, but you duplicated 3/3 for some
> reason.)
>
No i actually copy pasted your name wrongly, so i resent it again with
correct name.
> I can't accept that, please be more specific in your subject: line.
>
> Also, in the body, say exactly what checkpatch warnings you fixed, and,
> if you fixed more than one type of warning, that might indicate that you
> should break the patch up into different parts.
>
Ok. so similar changes constitute a patch, and if the change differs a
new patch should be there.
> So, I've dropped all 5 patches you've sent me, please redo and resend.
>
Thanks, i will redo again.
> thanks,
>
> greg k-h

Thanks,
Devendra.
