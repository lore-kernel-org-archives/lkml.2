Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab0FJSm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:42:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64607 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0FJSm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e0V9wZ3Xxx5Ra8te5BNtgt2OupsE9+L4rSeJQJuD+gjF+YP5XGLMYRzSuAp0/dLOd8
         zli2axN3kGWlcsXMyv087NFRSs5vuv8+/iVYmji3wnmR2VJjB91ubFSBIpcV+5i/c/dr
         mv3pxAWaVZ0A32NudOQ/7hSHcgcsniwIw2E1k=
MIME-Version: 1.0
In-Reply-To: <4C112E7B.1040101@nortel.com>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
	<4C112E7B.1040101@nortel.com>
Date: Thu, 10 Jun 2010 12:42:27 -0600
Message-ID: <AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>
Subject: Re: Aerospace and linux
From: Brian Gordon <legerde@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do work in telco stuff.  We use ECC RAM, turn on ECC/parity on the
> various buses, enable error-checking in the hardware, etc.

Excellent stuff when you have it. :)

> At higher abstraction levels you can checksum the data being stored and
> validate it when you access it.

What about .ro and .text sections of an executable?   I would think
kernel support for that would be required.   If its application data,
then all sorts of things are possible like you described.   Ive also
seen critical ram variables be stored in triplicate and then
compared/voted just to ensure no silent SEU corruption.

> You might start by taking a look at the "edac" code in the kernel.
> Linux in general doesn't normally enable all the fault detection code,
> so you may need to start looking at datasheets.

Thank you for the suggestion.  If the memory device supports EDAC/ECC
then definitely enabling it is a good strategy.
