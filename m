Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054Ab1JEQnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:43:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54569 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1JEQnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <20111005065617.GA6824@kroah.com>
References: <20111004232403.10364.22050.stgit@ponder> <20111005065617.GA6824@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 5 Oct 2011 10:43:02 -0600
X-Google-Sender-Auth: It5KM3CVsia8I2QqyHTDYAvw8CE
Message-ID: <CACxGe6si_i9mbVQFjbKYkq1H1QOp9UvQqrd=+2fYGrs63xzC1A@mail.gmail.com>
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 12:56 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:
>> For simple modules that contain a single platform_driver without any
>> additional setup code then ends up being a block of duplicated
>> boilerplate.  This patch adds a new macro, module_platform_driver(),
>> which replaces the module_init()/module_exit() registrations with
>> template functions.
>>
>> This patch also converts all the relevant spi drivers to use the new
>> macro.  There are a lot of drivers in the tree that are using this
>> pattern and could be converted.
>>
>> It also fixes up some incorrect section annotations where I found
>> them.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> I think this is useful, and I like the diffstat that it produces.
>> What does everyone else think of this approach?  I can do versions for
>> i2c_drivers and spi_drivers too.
>>
>> This is *not* tested very much.  I'm circulating mostly for review for
>> now.
>
> The idea looks sane to me, I like the diffstat it ends up creating, nice
> job.

Thanks.  Can I take that as your a-b?  Can I merge it via the spi tree?

g.
