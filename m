Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab0GAHyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:54:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51283 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0GAHyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MkNeduOFUEuRus0cFS/DSHwUrB7Yrnw9POt1XHl0yLKQS3v1fJtVPS+zpORGTHq5EQ
         SbQDDfIK1oYs1n6O/L45xVCOXn2JzzaeYR9pMGPK6x/Sfdkq6rFcqhKTUxQ4MK1ydPe1
         HkfPl6UJJkbaxlTFmbSKZnS0kKom/WHRK7wZ4=
MIME-Version: 1.0
In-Reply-To: <AANLkTik3PuXz0nkOl8Fik7oqPt4xqXxQiuUo_8so0f87@mail.gmail.com>
References: <4BFA730C.1010906@hanzlici.cz>
	<20100524230512.8cc7dfc1.akpm@linux-foundation.org>
	<87vdacl15j.fsf@openvz.org>
	<AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com>
	<20100614125716.b04fcd28.akpm@linux-foundation.org>
	<AANLkTik3PuXz0nkOl8Fik7oqPt4xqXxQiuUo_8so0f87@mail.gmail.com>
Date: Thu, 1 Jul 2010 09:54:07 +0200
Message-ID: <AANLkTiniwK7gdYAze3fZ7MSi1Wm8tvYWC5LYG_5chER1@mail.gmail.com>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, Kyle McMartin <kyle@mcmartin.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:25 AM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Mon, Jun 14, 2010 at 9:57 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Thu, 10 Jun 2010 11:06:17 +0200
>> Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:
>>
>>> > > I don't see anything which would generate this warning in 2.6.33.4's
>>> > > fs/fs-writeback.c:597. __RH must have mucked with it.
>>> > Already fixed in mainstream by
>>> > commit 7c8a3554c683f512dbcee26faedb42e4c05f12fa
>>> > Author: Jens Axboe <jens.axboe@oracle.com>
>>> > Date: __ Tue May 18 14:29:29 2010 +0200
>>>
>>> Do you send it to stable ? I am hitting the same bug and count is high
>>> on kerneloops (http://www.kerneloops.org/searchweek.php?search=writeback_inodes_wb)
>>>
>>
>> The commit didn't have a cc:stable in the changelog so no, it probably
>> wasn't backported.
>>
>> But that commit was later reverted anyway.  Hopefully when the real fix
>> gets merged, it will be backported.
>

Any news of this bug ?

Regard

Bastien
