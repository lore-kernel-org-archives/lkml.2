Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2JXFiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:38:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49057 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JXFiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:38:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121024041543.GA29712@kroah.com>
References: <20121019191038.GA18369@kroah.com>
	<1351047928-7234-1-git-send-email-yamanetoshi@gmail.com>
	<20121024041543.GA29712@kroah.com>
Date: Wed, 24 Oct 2012 14:38:11 +0900
Message-ID: <CAOTypNRcJT+EbyN6g6hzSLPh4uNyCfTHnhX3KVFdAxS6K0ODVQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging/sbe-2t3e3: Use netdev_ printks in main.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 1:15 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 24, 2012 at 12:05:28PM +0900, YAMANE Toshiaki wrote:
>> fixed below checkpatch warning.
>> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
>>
>> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>
> I never got the 3/3 patch in this series :(

I know!
# thanks, I will learn more ways to send patch

-- 

Regards,

YAMANE Toshiaki
