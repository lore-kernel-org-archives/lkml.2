Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1HVLo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:44:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46070 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1HVLoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <4E523F8D.8080902@cam.ac.uk>
References: <20110822100824.GA6671@maxin>
	<4E523F8D.8080902@cam.ac.uk>
Date: Mon, 22 Aug 2011 14:44:20 +0300
Message-ID: <CAMhs6YxhF5nhb=JMSVKWOVjiZXOehFZDESeYcrVvmU21fnrhdw@mail.gmail.com>
Subject: Re: [PATCH] staging: iio: industrialio-core: Fix compiler warning
From: Maxin B John <maxin.john@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Bryan Freed <bfreed@chromium.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 2:37 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 08/22/11 11:08, Maxin B. John wrote:
>> drivers/staging/iio/industrialio-core.c: In function
>> 'iio_device_add_event_sysfs':
>> drivers/staging/iio/industrialio-core.c:914: warning: 'mask' may be
>> used uninitialized in this function
> Thanks for the patch.  It's actually a driver bug if this occurs.
> We could have had a WARN_ON to let userspace know about the bug and
> indeed taken the error route you suggest but
> the relevant code has actually undergone a rewrite anyway so the
> bit you are fixing doesn't exist any more anyway.

 Yes, That makes more sense.

> See http://git.kernel.org/?p=linux/kernel/git/jic23/iio-blue.git;a=summary
> For our current dev tree (eats babies and includes all sorts of stuff
> that hasn't been reviewed yet - so beware).

Thanks for sharing  this (scary) info :)

Best Regards,
Maxin
