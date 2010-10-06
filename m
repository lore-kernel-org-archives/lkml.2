Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0JFEan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:30:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50616 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0JFEam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EZy8emmfQJQPqQcIbP3zc1ZINBhjmeakJTR0CyWpV2r98cank780exB3OBQPlprA22
         F+t/wD1TCbGW9ZLO7f/yJyrJ9G62IapIfU7sF7etVEETYFre6+NzKs2ickAqGBN337Ar
         VjVQFvknmqhkNkG11tr/9/iLznbgg4911Ukcw=
MIME-Version: 1.0
In-Reply-To: <20101006034210.M38114@admin-gateway.ncra.tifr.res.in>
References: <20100922052107.M44650@admin-gateway.ncra.tifr.res.in>
	<20100922145607.GB26309@suse.de>
	<20100923100127.M64470@admin-gateway.ncra.tifr.res.in>
	<20100923140236.GB31394@suse.de>
	<20100928091520.M79654@admin-gateway.ncra.tifr.res.in>
	<20100928113036.GA15024@suse.de>
	<20100928115204.M46802@admin-gateway.ncra.tifr.res.in>
	<20100928120743.GA15807@suse.de>
	<20101004042924.M50398@admin-gateway.ncra.tifr.res.in>
	<20101005104403.M28756@admin-gateway.ncra.tifr.res.in>
	<20101005133312.GF3548@suse.de>
	<20101006034210.M38114@admin-gateway.ncra.tifr.res.in>
Date: Tue, 5 Oct 2010 23:30:40 -0500
Message-ID: <AANLkTim+LsaL0QeQPwNjFA3F-hzkZs-HqghM0o6Us9TD@mail.gmail.com>
Subject: Re: pl2303_ttyUSB0 userspace application not able to control RTS line
From: Greg Oliver <oliver.greg@gmail.com>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 11:14 PM, Raju Rameshwar Uprade
<rajsingh@ncra.tifr.res.in> wrote:
>
>> Is this your "modified" driver?
>
>  No..It's pl2303.
>
>>
>> I don't see that error in the kernel log below at all.
>
>  sometimes I got that error.
>
>> What kernel version is this?
>
>  2.6.35
>
>> And are you sure that your device actually has the RTS lines connected?
>> I have seen a number of these devices that do not bring those lines from
>> the chip to the rs232 connection.
>
> I have connected a RS-485 interface card to this usb-to-serial converter which has
> MAX-485 IC ( Line driver chip which convert RS-232 to RS-485),of which pin number 2 is
> for RTS line.
>
> Through my modified pl2303 device driver, I am able to enable/disable the RTS line as
> per my need,as I told in my earlier email.
>
>> You really might want to go purchase a "real" usb to serial converter
>> that works properly, the pl2303 devices do not fit that category.
>
> Yes, I am also thinking of purchasing a "real" usb to serial converter.
>
> Thanks a lot Greg, I have learned a lot interacting with you.

You know - I have had the (mis)forune of working with some of your
people - straight out of college..  While I was impressed with their
capacities, I was duly unimpressed with their inability to shut the
fuck up when appropriate.  If they knew that a typo on the command
line was more easily correctable after the fact (since of course set
-o vi ) was in place..  then they may (I DOUBT IT) shut the fuck
up....  Anyhow - just a pissed off observation...

Teach them to STFU when noone asked them shit to begin with....  Or -
put a dick (my dick) in their mouths....
