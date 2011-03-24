Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1CXShL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:37:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55709 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab1CXShF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=jQRC48/cv0fTo7jEntpjKYepeA4YQljiHVzXzhZxBERA183vh8yavSZw6WusqdW6kc
         niJjwywJ4TUDyV1s3YbUSnUlEHwWEjwhoKTtZe32U6eqT39puZS74SsRu5F9guUMX3+u
         rWk4pfX2bmbYZES+A33xut4PgftIHhslXJiqw=
MIME-Version: 1.0
In-Reply-To: <20110324183205.GI3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com>
 <20110324174722.GH3130@pulham.picochip.com> <AANLkTinDWA1xU1G0kBk8XPr_ZaRgHtBQP60DX6-x3tsn@mail.gmail.com>
 <20110324183205.GI3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 14:36:42 -0400
X-Google-Sender-Auth: -McJHmtVuzoGIAi8ggCnOIJZk3A
Message-ID: <AANLkTimP7_ADTd+9Wyc4tLtsXVnS=1EwTac1Z8CtgHV2@mail.gmail.com>
Subject: Re: [RFC PATCHv2 0/4] Support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 14:32, Jamie Iles wrote:
> On Thu, Mar 24, 2011 at 01:56:17PM -0400, Mike Frysinger wrote:
>> just an overview note here ... the Blackfin OTP is actually IP we
>> bought from someone (not sure if i can say more, although i dont know
>> the details myself ... i'd have to go ask around), so much of the
>> feedback i give about the structure of it most likely (hopefully) be
>> applicable to other people who have purchased this IP.  if/when anyone
>> who is also using this IP steps forward, we could even see about
>> generalizing the bfin-otp driver.
>
> Yes, we have a similar thing here - a block of OTP from an IP vendor and
> a wrapper to provide an AXI interface.  As far as I know there are only
> a few OTP vendors so there may well be plenty of common code in
> different OTP implementations.

do you guys wrap the interface ?  the Blackfin processors have an
on-chip ROM which provides higher level functions like
read/write/lock/etc...  the Linux driver uses those rather than
programming the memory mapped OTP interface itself since this
interface is not publicly documented.
-mike
