Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0EaHGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:06:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54510 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0EaHGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ncYQ9E2143ZtG5JgSC3qzqsNoOXAHs+fAX4yy2JqDnxEUb0fZlqZu7cccSM1mjqyo/
         5YtUNhpKrcTsm2Je12ziMxzP9LbPIuQ0I0q9OaNWoCReuKyE/CH7FLgDb3jioIOw7PCj
         MkwjtnQJqfqKUGbTBXXIViYuROUUAxJQX/85E=
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <AANLkTinAnHYDxFEKT69jPXZVoQ0I2Lmx4Q5I_kPDBugv@mail.gmail.com>
References: <vbf0pu1dqa60ojk7uuublww9.1275282082699@email.android.com>
	 <AANLkTinAnHYDxFEKT69jPXZVoQ0I2Lmx4Q5I_kPDBugv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 10:06:42 +0300
Message-ID: <1275289602.3544.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 16:09 +1000, Dave Airlie wrote: 
> On Mon, May 31, 2010 at 3:03 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > I'll test again this week.  I still don't see how these small patches could cause issues with suspend/resume unless we set oops_in_progress during that time on your machine...
> >
These do work fine. I guess that was something unrelated.
Sorry for noise!


Best regards,
Maxim Levitsky

> > Jesse
> 
> I've just given these a test on the EL6 kernel, and they seem to be
> working well for me here,
> 
> They don't seem to break s/r here at least, and I can see crashes now
> on screen which is a win. I'll get some time to try and set them up
> for upstream asap.
> 
> Dave.


