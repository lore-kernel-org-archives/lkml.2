Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886Ab0I0VZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:25:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782Ab0I0VZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cd6RL7d7qutvfYwW5aAHVTWwUGaqR0XGurmJatbRhWnESWsO6sVT3ioC+6ixuWlWTn
         m1R6PMrPY0eUnV5ufBOe8q7gTmA4EzpNLk12bYVHFGpwv+xzu1DhuaSEXxZ86Zpt3zs8
         t3tm5QJe788nsdfSHxK/gNh272CS2e7o58FJ8=
MIME-Version: 1.0
In-Reply-To: <20100927211842.GA19667@foursquare.net>
References: <20100924041410.GA18040@foursquare.net>
	<20100924060557.GA21238@foursquare.net>
	<20100924064446.GA22588@foursquare.net>
	<AANLkTinQ20uSgFP5KV17B0J0v8Y0zAg=AgAd_kf+4Bh0@mail.gmail.com>
	<20100927211842.GA19667@foursquare.net>
Date: Mon, 27 Sep 2010 23:25:11 +0200
Message-ID: <AANLkTinYjJ8m6UjsR++zFCxo4jecDEzCAX_F_CF6NwZV@mail.gmail.com>
Subject: Re: ext3 filesystem corruption in user mode linux
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 11:18 PM, Chris Frey <cdfrey@foursquare.net> wrote:
> On Mon, Sep 27, 2010 at 11:04:07PM +0200, richard -rw- weinberger wrote:
>> On Fri, Sep 24, 2010 at 8:44 AM, Chris Frey <cdfrey@foursquare.net> wrote:
>> > On Fri, Sep 24, 2010 at 02:05:57AM -0400, Chris Frey wrote:
>> >> So far I have been unable to make 2.6.32.21 corrupt its filesystem
>> >> when running as the UML kernel (Host 2.6.35.4, UML 2.6.32.21)
>> >
>> > Spoke too soon... 2.6.32.21 has errors too, if pushed hard enough.
>> >
>>
>> can you do a git bisect?
>
> I've been trying, but so far the range of buggy versions stretches back
> to 2.6.32.x at least.  I'm trying to find a version that doesn't have
> this issue.
>
> I'm kinda surprised that nobody else has run into this.  Or maybe user
> mode linux isn't used as much as I thought?   Or I'm just doing something
> completely bone headed. :-)

Hmm, maybe this issue affects only your configuration.
When I have some spare time I'll try to trigger this on my setup.

-- 
Cheers,
//richard
