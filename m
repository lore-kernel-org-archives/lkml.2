Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab0FKEeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:34:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35976 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0FKEes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J69Zqel+NbxIWr+QO1bnnrjZlgh5JtLKdjqNtLJ8rMHnVZqkgjwAEeRPkAynmmLejk
         YILWemzJLJerm2/ylyxMfJSXMtJJgyJi7aOnLE7awZ7+kvG6Z8ANRl1jQhJtp12IeBFK
         vNlI13LguzjdrkNgfuOYhalk0IO/4M9E+EeyU=
MIME-Version: 1.0
In-Reply-To: <4C118844.2020401@gmail.com>
References: <AANLkTimVgcnvb-obG4As0jjZQk6rwsHd-ByrfL4KxP0A@mail.gmail.com>
	<4C118844.2020401@gmail.com>
Date: Fri, 11 Jun 2010 10:04:46 +0530
Message-ID: <AANLkTilm0X3Uckl1S926hSPYRxh7jDeUm0WITOqac9V1@mail.gmail.com>
Subject: Re: O_NONBLOCK with Ext2/3
From: "Yedire, Sandeep" <syedire@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2010 06:20, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 06/10/2010 06:44 AM, Yedire, Sandeep wrote:
>>
>> Hi All,
>> What is the effect  on filesystem blocks,data blocks if O_NONBLOCK
>> flag is used with a test application doing write to a file(64MB) on
>> NAND Flash.
>> Can any one please let me know
>> Regards,
>> Sandeep.Yedire
>
> O_NONBLOCK doesn't do anything on regular files, as far as I'm aware. It's
> only useful on sockets, serial ports/TTYs, etc.
>

[Sandeep] In Ext2 fs, I have noticed many frequent updates to data
blocks as compared to without this flag. I also noticed Dirty page
limit (44MB max)  with O_NONBLOCK and 18 to 20MB max without this
flag. Because of this there is less Filesystem block updates with
O_NONBLOCK flag.

In case of Ext3, Dirty page limit is 18-20MB with or without this flag.
Its same with all modes of Ext3(data, ordered, writeback).

This is actually my concern.

Many Thanks,
Sandeep
