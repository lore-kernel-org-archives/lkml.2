Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0FOIZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:25:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51052 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab0FOIZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=awVLLaPKXQn+dR7OV/LtvrMz6cRw4GH5rB2TF7+7uGn8+GAOssU4o8Ry2yPmx+e0Bh
         vXEvjWeskMhtUydnJljzanpxoauzm3TlinQeTHu6Sgct8o9GbIhlZZ9XRP5RtU4nQyZ4
         hdxL6YEtoEL3ClIumQNZjkpKKm9cQe9ncP0OU=
MIME-Version: 1.0
In-Reply-To: <20100614125716.b04fcd28.akpm@linux-foundation.org>
References: <4BFA730C.1010906@hanzlici.cz>
	<20100524230512.8cc7dfc1.akpm@linux-foundation.org>
	<87vdacl15j.fsf@openvz.org>
	<AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com>
	<20100614125716.b04fcd28.akpm@linux-foundation.org>
Date: Tue, 15 Jun 2010 10:25:12 +0200
Message-ID: <AANLkTik3PuXz0nkOl8Fik7oqPt4xqXxQiuUo_8so0f87@mail.gmail.com>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 9:57 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 10 Jun 2010 11:06:17 +0200
> Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:
>
>> > > I don't see anything which would generate this warning in 2.6.33.4's
>> > > fs/fs-writeback.c:597. __RH must have mucked with it.
>> > Already fixed in mainstream by
>> > commit 7c8a3554c683f512dbcee26faedb42e4c05f12fa
>> > Author: Jens Axboe <jens.axboe@oracle.com>
>> > Date: __ Tue May 18 14:29:29 2010 +0200
>>
>> Do you send it to stable ? I am hitting the same bug and count is high
>> on kerneloops (http://www.kerneloops.org/searchweek.php?search=writeback_inodes_wb)
>>
>
> The commit didn't have a cc:stable in the changelog so no, it probably
> wasn't backported.
>
> But that commit was later reverted anyway.  Hopefully when the real fix
> gets merged, it will be backported.

Thank Andrew. I am hitting this warning at each boot, without anything
fancy on my machine
(I am hitting it just after mounting the root partition, i suppose
reiserfs user_xattr, acl help but I was expecting that automatic
testing could catch this kind of bug)

Regards

Bastien
