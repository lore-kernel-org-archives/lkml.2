Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab0FJTht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:37:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60555 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab0FJThr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kw7cwE/l+yYnT5iE36/OArCatIpXiEIXZRJDZFNimceVxWmnkxPUaUTXkxFrGln6zk
         gnsg+hKsfKjIc12sOqg9pCAK6fOseHzcc2hOqYM8VT+rr8rB6LApccYwE4UOgGL2483p
         z/kDSU9TJwIBrSzWtP0xtPl7HwOFiF6NQlqxU=
MIME-Version: 1.0
In-Reply-To: <4C113BC2.6070000@libero.it>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
	<4C112E7B.1040101@nortel.com>
	<AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>
	<4C113BC2.6070000@libero.it>
Date: Thu, 10 Jun 2010 13:37:46 -0600
Message-ID: <AANLkTikrKsMagIl0bmcDC4j98_MZrExyoduQXEy_ak3H@mail.gmail.com>
Subject: Re: Aerospace and linux
From: Brian Gordon <legerde@gmail.com>
To: Massimiliano Galanti <massiblue@libero.it>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes.  Thats exactly what I am looking for.   Even if there is a speed
penalty, I wouldn't mind so much.  However wikipedia says that XIP is
filesystem dependent and im stuck with FAT32 or NTFS.   Wikipedia
claims NTFS can do XIP.   Is this true under linux?

On Thu, Jun 10, 2010 at 1:23 PM, Massimiliano Galanti
<massiblue@libero.it> wrote:
>
>> What about .ro and .text sections of an executable?   I would think
>> kernel support for that would be required.   If its application data,
>> then all sorts of things are possible like you described.   Ive also
>> seen critical ram variables be stored in triplicate and then
>> compared/voted just to ensure no silent SEU corruption.
>
> Maybe slightly off topic but... if flash is safer than ram, what about using
> XIP (where possible, e.g. on NORs)? That would not put .data sections into
> ram, at least.
>
> --
> Massimiliano
>
