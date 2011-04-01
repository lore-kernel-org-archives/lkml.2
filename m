Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab1DAAKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 20:10:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62842 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1DAAKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 20:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=grXMQ7dkyVkkSdPwqBxnjdBE7+1tsIvex2sJuE50JuvkAKQiXdr865M2tm5ywbsRtx
         j4T3CXDjStHphVqSEUgpeo8kpeCbGGQAr9S1LGjUdna9VuIkB5uWDQ2S+KpbgNeN2Udk
         CjDzF20CoaHWP7xUADYom4xUfI1jK2mFpJczk=
MIME-Version: 1.0
In-Reply-To: <20110227095154.2741d051.randy.dunlap@oracle.com>
References: <20110227095154.2741d051.randy.dunlap@oracle.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 31 Mar 2011 20:09:57 -0400
Message-ID: <AANLkTikQ3k_E1-7Hnxdgm1xRo4Q+Skw_-Yn_T4K35D2V@mail.gmail.com>
Subject: Re: [PATCH] media/radio/wl1273: fix build errors
To: Randy Dunlap <randy.dunlap@oracle.com>, stable@kernel.org
Cc: linux-media@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Mauro <mchehab@infradead.org>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 12:51, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> RADIO_WL1273 needs to make sure that the mfd core is built to avoid
> build errors:
>
> ERROR: "mfd_add_devices" [drivers/mfd/wl1273-core.ko] undefined!
> ERROR: "mfd_remove_devices" [drivers/mfd/wl1273-core.ko] undefined!

2.6.38 stable worthy ?

now in mainline as 1b149bbe9156d2eb2afd5a072bd61ad0d4bfaca7 ...
-mike
