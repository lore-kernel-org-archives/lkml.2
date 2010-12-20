Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0LTLsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:48:35 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58190 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0LTLse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BuaxxZVsAVqaCd6bqjxk/RCjCyrGLz7GbMOl1A/zYOImf1+NNspR6Sv7T2EiQbnMjo
         3TNxco39KSDPqdXS9acsK8sAeE6xKH+NWbKYD4WBJ4ocqwQ777h9qe5Won1FqZ0paYXx
         HJzx6f6uN49tqx3YBnXMQ6+foHRaz0bNsrdKA=
MIME-Version: 1.0
In-Reply-To: <1292836937.22702.424.camel@Joe-Laptop>
References: <4D0DD027.4000507@gmail.com>
	<1292813544.22702.342.camel@Joe-Laptop>
	<AANLkTi=WP9k_yqyvvJmy2ZW0ErO9Yt=jQjVvWQ_RGByv@mail.gmail.com>
	<1292836937.22702.424.camel@Joe-Laptop>
Date: Mon, 20 Dec 2010 12:48:33 +0100
Message-ID: <AANLkTimNe7_3Za6YgY69zEuXYCmU4dZdCjfLN2QMM=jb@mail.gmail.com>
Subject: Re: [PATCH][RESEND] scripts: add no-warning option to the checkpatch script
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Joe Perches <joe@perches.com>:
> On Mon, 2010-12-20 at 09:37 +0100, Marco Stornelli wrote:
>> 2010/12/20 Joe Perches <joe@perches.com>:
>> > Why do you think it's useful?
>> To "debug" a patch from style point of view, I think it's useful to
>> fix before the errors and then the warnings. So this option it's
>> useful as a "filter". However, I added you in cc: because of a reply
>> to my first patch that indicated you as a person interested in this
>> scope.
>
> Perhaps then it'd be better to filter/enable/disable
> the 3 current categories of messages.
>
> Maybe something like this:

Yeah, very good. Will it be inserted in mainline?

Marco
