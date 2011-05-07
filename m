Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab1EGEcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 00:32:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49138 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1EGEc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 00:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=OA1LSqPNtUfKYVGBc8RGfOrhZS5JnP/tGkTfmUw2AR577lGqYfRfsVJ0Zbi8fmENU4
         /dIvPchhjlygI9V2AYtuwHaiVnhKG+gQkIJi9CNNDM3qcr2iD3UVGN6v0XtMASCjcVVH
         46ZmrR/vrZ8hkXTwFJQm7ciNGGNOQgCCcSAq0=
MIME-Version: 1.0
In-Reply-To: <20110507003818.GA23997@kroah.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com> <20110507003818.GA23997@kroah.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 6 May 2011 21:32:08 -0700
X-Google-Sender-Auth: OiQlIJGUI_1waA6GWJ2tfbBtYKg
Message-ID: <BANLkTinHPkUFLDpsyReruQOhE45pbYyJwQ@mail.gmail.com>
Subject: Re: [RFC 0/2] x86: Add support for Atheros AR1520 GPS devices
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, allen.kao@atheros.com,
        roman.gezikov@atheros.com, joonas.viskari@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 5:38 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, May 06, 2011 at 03:09:38PM -0700, Luis R. Rodriguez wrote:
>> These two patches adds support for the Atheros AR1520 GPS device,
>> currently only pegged onto an mrst platform. This creates a character
>> device called ar1520 and lets userspace talk to it through it. My only
>> concern against this approach is that it this requires a custom userspace
>> application for reseting the device, waking it up and for blocking reads
>> through ioctl. The character device can be used to read/write data to it
>> as well.
>
> I really don't like using a character device for this, what's wrong with
> a tty device instead like other GPS devices are using today (i.e. a
> number of USB GPS devices)?
>
> I don't understand what these ioctls are supposed to be doing, can't
> they map to standard tty ioctls that we already have for flow control so
> that userspace doesn't have to write a whole new application just to
> talk to yet-another-gps-device?

Thanks for the review, will relay this back.

  Luis
