Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0KUVsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:48:16 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50979 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0KUVsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:48:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=kJCzbgLO7ZYfPegMb2qNE0NkpT/j99v76QuKMWck1AIKJqrKn8jgMXtpwAiWuqGX6q
         On+RLyY6xfv4bZjy9ACfSpVfkNoERE9W/xh/QUxlIEm90ZEmZyh2FkoF9LisWeJkXqN9
         VW3IL9G7anq/Xt8MOJ5ApEoV4WF/oCByebeh4=
MIME-Version: 1.0
In-Reply-To: <20101121214407.GH23423@thunk.org>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu> <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
 <20101121130236.GE23423@thunk.org> <20101121172906.GD3703@kroah.com>
 <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
 <20101121203124.1ba8212e@lxorguk.ukuu.org.uk> <20101121214407.GH23423@thunk.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 21 Nov 2010 22:47:53 +0100
Message-ID: <AANLkTinEm1mLAtPZdEp2sHRfKPeV6qYP8f9Dbbr92_JD@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 10:44 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Nov 21, 2010 at 08:31:24PM +0000, Alan Cox wrote:
>>
>> Which we know in practice they won't. They'll sit on fixes (often
>> security fixes) and tweak and add private copies of features. In turn the
>> Linux one could then only keep up by adding features itself - which would
>> have to be GPL to stop the same abuse continuing.
>>
>> It's a nice idea but the corporations exist to make money and adding
>> proprietary custom stack add-ons is clearly a good move on their part to
>> do that.
>
> Hence my recommendation that if someone is going to do the work to
> create a 802.11 layer that has shims that work on multiple operating
> systems, it be GPL with explicit exceptions to allow said layer to
> work on legacy operating systems like QNX, et. al.  That way it forces
> the hardware specific code to be released under the GPL --- if they
> want to take advantage of the "write onces, work on multiple operating
> systems" feature.
>
> If someone is going to go through all of this work to make it possible
> --- particularly if it's at a company such as Luis's employer, or any
> other wifi chipset provider --- why should it allow their competitors
> to do closed source drivers?  Better to structure the driver licensing
> such that (a) there is benefit for companies to make a Linux driver by
> using this common stack, and (b) but in exchange, it forces them to
> make a driver which is guaranteed to be usable by Linux by virtual of
> the fact that (1) the native interface is Linux's wireless stack, and
> (2) the license forces them to GPL their driver.

By forcing the driver to be GPL, you automatically exclude Windows
from the list of platforms supported by such a cross-OS driver, as the
Windows NDIS headers are AFAIK under a GPL-incompatible license, so no
GPL driver can be written for Windows.

>
>                                   - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
