Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2FTXeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:34:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64358 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2FTXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:34:03 -0400
Date: Wed, 20 Jun 2012 18:33:54 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
Message-ID: <20120620233307.GA3120@burratino>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
 <20120615220343.GA8928@kroah.com>
 <CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
 <20120618222550.GB11737@kroah.com>
 <CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
 <20120620223754.GA5864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620223754.GA5864@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Tue, Jun 19, 2012 at 10:00:36AM +0800, Ming Lei wrote:

>> If Documentation/stable_kernel_rules.txt is the correct doc for stable rule,
>> looks reporter requirement isn't listed in the file, but the below can be found:
>>
>>           - No "theoretical race condition" issues, unless an explanation of
>>          how the race can be exploited is also provided.
>>
>> so I marked it as -stable because I have explained how the race can be
>> exploited in reality.
>
> Ok, but as this has been there since when, 2.5, I'll refrain from
> marking it this way, as no one has reported a real problem like this
> before.

Just to clarify, if I understand correctly, exploited != reproduced. :)

That is, if you have an example of how the race can be exploited by an
unprivileged prankster to make a sysadmin's life miserable, that would
definitely be real problem.  On the other hand, if you have a test case
for a rare race condition that has not appeared in the wild and is not
exploitable, that's very useful (test cases make programming much
easier!) but it doesn't make it qualify for stable.

Hope that helps,
Jonathan
