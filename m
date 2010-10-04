Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0JDLE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:04:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35285 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0JDLE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z7nNbwIGpbTgp2wcK+PTRtkwvRcQ7RnTboktVK+hWoIbHdGIIXBz1d0iRIXO1miODd
         sI/miYFf00FFkOavIkDpP8H0Hfo9FllDsL/OpWJpThfpGooutcZbWjF5FX7GSxRVDTz+
         /+R3EsTtcDilLE80fg4k2cJuU+YMBtpsy5hMI=
MIME-Version: 1.0
In-Reply-To: <20101004101200.GI5189@cr0.nay.redhat.com>
References: <AANLkTik-RXPfDK12m5OFmLf=gVL1x-h-aDcKX2nz6O3P@mail.gmail.com>
	<20101004101200.GI5189@cr0.nay.redhat.com>
Date: Mon, 4 Oct 2010 08:04:24 -0300
Message-ID: <AANLkTi=UDned6J0SbcFAfsiF1rg=E-+ZUE2TN=KOg0-f@mail.gmail.com>
Subject: Re: Information From Buffers
From: Artur Baruchi <mail.baruchi@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang.

Thanks for your reply.

No, inside /proc/meminfo there are just high level information (macro)
about what is going on inside the memory. I need do get more details
about page cache, things like, what files are being buffered, how much
files are being buffered, size of this files, etc. This information
can be reach using buffer_head linked list, but I dont know how to
walk through this list.

Thanks.

Att.
Artur Baruchi


On Mon, Oct 4, 2010 at 7:12 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Oct 01, 2010 at 03:27:04PM -0300, Artur Baruchi wrote:
>>Hi Guys.
>>
>>I would like to get more information about how cache/buffers are being
>>used by kernel. Is there a way to walk through the buffer_head list
>>and get these details ?
>>
>
> In /proc/meminfo, there are "Buffers" and "Cached" fields, are they
> what you are looking for?
>
