Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946Ab0KRQyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:54:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53931 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab0KRQyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=boXtsnbFIDkp2XX67eSYngkjJ2L0HcaUJMtQB4rstdDe2jBaRuE8YASXJ7DxQlox+X
         6Jp4LtcvfrXFy50A7yns2xA667NWf4MPMQljsvBGVrDW8oUI84YWujOA/Y243z9ARoSv
         9M4T8PkYYNUDO6ffg/MKU7Hl4HArgJ7C68Vjw=
MIME-Version: 1.0
In-Reply-To: <20101118164552.GC2855@kroah.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com> <20101118164552.GC2855@kroah.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 08:53:22 -0800
X-Google-Sender-Auth: gwEhM8rhXNtDjIXO3TzWHnHszRo
Message-ID: <AANLkTing6JkfH=n2GfWtW+2=5oB40FDM-TYPvzd+PPkH@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 8:45 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 18, 2010 at 12:46:37AM -0800, Luis R. Rodriguez wrote:
>> Can Linux help in any way? What if we used staging for a common driver
>> architecture for different OSes? Most of those staging drivers already
>> have some sort of OS agnostic cruft, why not try to help hardware
>> vendors by providing them with a common OS agnostic solution they can
>> share? Is this not out turf? If its not, are we perfectly OK in being
>> second citizens so long as the driver eventually gets done on proper
>> upstream Linux ? I'm not OK with it and hence my e-mail. I'm looking
>> for ideas and thoughts on this. Please no trolls, would really just
>> like some constructive discussions on this. As I see it maybe we can
>> move some of this OS agnostic crap into staging, and then use spatch
>> to write tools to de-unwrap crap to Linux specific stuff and help
>> maintain it. What this does is it moves OS agnostic crap out as a
>> community effort to help aid proper development and porting for Linux.
>> Since we'd maintain the crap / scripts / de-wrappers, we'd likely be
>> able to get drivers quicker and can have a framework to help companies
>> who still [1] need to support other Operating Systems.
>
> No, staging is for gettingn code into, or out of, the kernel tree, not
> for anything else.
>
> I have allowed it to be used to hold drivers in that are not
> "acceptable", while another driver was written by others from scratch to
> work properly on that hardware, and then the original one is dropped.
> That's ok, as there is a time-limit on how long the code lives in the
> staging tree.
>
> But to try to use it to create a multi-os solution, no, that's not what
> staging is for.

OK thanks!

> Also, please review the past multi-os driver initiatives that have
> sprung up over the years (about 1 every 10 years it seems).  Please
> learn from the past as to why those have failed every single time, and
> why we don't want to even try to do that again.

:-) thanks, just testing waters to see what's possible and what
direction to focus more on.

  Luis
