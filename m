Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1CNKhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:37:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53536 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1CNKhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QOm+x3QXs1/ipCfLQLWn9WFIZxUI6G5mttRmJDdRnIrtPU2jlxqAtYIx2zNI5rW6XQ
         qV2oU3/NxES1hATBpLilv7x8eWcXsJshn1YGyVqo62IiicZqWt7PUu7B7UQVNwBmthx6
         y0avakQpj/Lw/vlclwI+EpqnKcKWMTc1bBHpo=
MIME-Version: 1.0
In-Reply-To: <20110314101117.GB31153@sortiz-mobl>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
	<1299224747-11081-1-git-send-email-myungjoo.ham@samsung.com>
	<20110314101117.GB31153@sortiz-mobl>
Date: Mon, 14 Mar 2011 19:37:46 +0900
X-Google-Sender-Auth: M0cN6STB2c1P3FiSorcXKfIo9Ec
Message-ID: <AANLkTi=r0pWYn1oeBXvOutMxXgRVQjRD1K6r4xWzRo9r@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAX8997/8966 MFD: Add IRQ control feature
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

On Mon, Mar 14, 2011 at 7:11 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>
> Hi MyungJoo,
>
> On Fri, Mar 04, 2011 at 04:45:47PM +0900, MyungJoo Ham wrote:
> > This patch enables IRQ handling for MAX8997/8966 chips.
> >
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Joe's comments make sense. Also, here are my comments:
>

Yes, in the patch series of MAX8997/8966 version 5, his comments are
applied at "[PATCH v5 3/4] MAX8997/8966 MFD: Add IRQ control feature".

[]

> All the (1 << n) parts could be nicely replaced with relevant #define. That
> would make your code more readable.

[]

> There are a lot of magic constants here, and I'd love to see that replaced as
> well with some more descriptive macros.
>

Thanks. I will post "PATCH v6" with some macros for the register bits.


> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/


Cheers!
 MyungJoo
--
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
