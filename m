Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab2EAEJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:09:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52643 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2EAEJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:09:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120430201855.GN6447@mwanda>
References: <1335813977-8096-1-git-send-email-josephdanielwalter@gmail.com>
	<20120430200444.GM6447@mwanda>
	<20120430201855.GN6447@mwanda>
Date: Tue, 1 May 2012 10:09:46 +0600
Message-ID: <CAFDqYy3GYch+C2c7Kvg3zvryCvY9d-rk=xi2KfbHb34dVz+Jzw@mail.gmail.com>
Subject: Re: [PATCH] staging/iio/meter: fix the coding style problem
From: joseph daniel <josephdanielwalter@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 2:18 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Apr 30, 2012 at 11:04:44PM +0300, Dan Carpenter wrote:
>> On Tue, May 01, 2012 at 01:26:17AM +0600, joseph daniel wrote:
>> >
>> > Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
>> > ---
>> > Hi Lars,
>> >     Thanks for review. how about the below change?
>
> Lar's review is the correct one.  It's cleaner to use
> get_unaligned_be32().  You'll need to include <asm/unaligned.h>
>
Thanks For the info Dan. i will be taking your comments in the code change.
> regards,
> dan carpenter
>
Thanks,
Joseph.
