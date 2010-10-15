Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0JOMGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:06:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab0JOMGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:06:18 -0400
Message-ID: <4CB84393.3020205@redhat.com>
Date: Fri, 15 Oct 2010 09:05:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <201010151045.45630.hverkuil@xs4all.nl> <20101015020526.1819545f.akpm@linux-foundation.org> <201010151202.31629.hverkuil@xs4all.nl>
In-Reply-To: <201010151202.31629.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-10-2010 07:02, Hans Verkuil escreveu:
> On Friday, October 15, 2010 11:05:26 Andrew Morton wrote:
>> On Fri, 15 Oct 2010 10:45:45 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> On Thursday, October 14, 2010 22:06:29 Valdis.Kletnieks@vt.edu wrote:
>>>> On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
>>>>> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> 
> Mauro, is this something for you to fix?

I have a patch fixing this conflict already:

http://git.linuxtv.org/mchehab/sbtvd.git?a=commit;h=88164fbe701a0a16e9044b74443dddb6188b54cc

The patch is currently on a separate tree, that I'm using to test some experimental
drivers for Brazilian Digital TV system (SBTVD). I'm planning to merge this patch, among
with other patches I received for .37 during this weekend.

The problem were due to a conflict between a BKL patch and your patch.

Cheers,
Mauro.
