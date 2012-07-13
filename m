Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422682Ab2GMPRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:17:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52347 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2GMPRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120713140814.GB10240@kroah.com>
References: <1342146469-26206-1-git-send-email-marcos.souza.org@gmail.com>
	<20120713140814.GB10240@kroah.com>
Date: Fri, 13 Jul 2012 12:17:43 -0300
Message-ID: <CAH0vN5K+y-2mRocmYpxof1vPGZAztBqJyh-psMwsK1c=7i_6eQ@mail.gmail.com>
Subject: Re: [PATCH v2] staging: sbe-2t3e3: Remove code that will never execute
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, khc@pm.waw.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/13 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Jul 12, 2012 at 11:27:49PM -0300, Marcos Paulo de Souza wrote:
>> This patch removes all references of "if 0" blocks in the sbe-2t3e3 driver.
>>
>> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
>> ---
>>  drivers/staging/sbe-2t3e3/2t3e3.h    |    3 --
>>  drivers/staging/sbe-2t3e3/cpld.c     |   15 ---------
>>  drivers/staging/sbe-2t3e3/ctrl.c     |   19 +++--------
>>  drivers/staging/sbe-2t3e3/dc.c       |   17 ----------
>>  drivers/staging/sbe-2t3e3/exar7250.c |   40 +++--------------------
>>  drivers/staging/sbe-2t3e3/exar7300.c |   17 ----------
>>  drivers/staging/sbe-2t3e3/intr.c     |   60 ++--------------------------------
>>  drivers/staging/sbe-2t3e3/io.c       |   21 ------------
>>  8 files changed, 10 insertions(+), 182 deletions(-)
>
> When sending out a v2 version of a patch (or any version after the
> first), please detail what changed between them.  The diffstat didn't
> look different here, but the patch did.  What happened?
>
> thanks,
>
> greg k-h

Hi greg,

I put some info between the commit message and the lines changed:

"Just fix the commit message fo sbr-2t3e3 to sbe-2t3e3"

So, looking at this now, I forgot to put a "Changes from v1" to
identify what was changed.

Thanks and sorry for that.

-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
