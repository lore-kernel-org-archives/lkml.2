Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2ILHgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:36:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39656 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2ILHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120911190829.GA3327@kroah.com>
References: <20120904202053.GA23449@kroah.com>
	<1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
	<20120911190829.GA3327@kroah.com>
Date: Wed, 12 Sep 2012 16:36:19 +0900
Message-ID: <CAOTypNRQn+yTH8jkDf2u+DAV42HM-igrxS4JO2NLu2U2PgS_7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging/vme: Use pr_ printks in vme_user.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>,
        linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 4:08 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Sep 11, 2012 at 04:16:14PM +0900, Toshiaki Yamane wrote:
>> The below checkpatch warnings was fixed,
>>
>> -WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
>> -WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
>> -WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
>
> A lot of these can be using dev_* instead of the pr_* functions, right?
> Please convert to using them wherever possible.
>
> Because of that, I can't take this patch, sorry.  Care to redo it?

Yes. Is this collect?

I must use dev_* procedure when the following conditions are met:
- If I have access to struct device object by the argument of the procedure
- Except for the right: struct net_device, etc.

Otherwise, I must use pr_* procedure.


Regards,

YAMANE Toshiaki
