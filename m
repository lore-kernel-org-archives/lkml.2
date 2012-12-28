Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab2L1Fia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 00:38:30 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61835 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2L1Fi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 00:38:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAE0An6f5LkjoZU-F6OtNXVo_jWz3XWhS+Zk06vAKZH4aRYDApQ@mail.gmail.com>
References: <CAD0Gp_YYu+LQr1rKResm_v3pYd+1M5G9kee7e4RJ1TUML7kq_g@mail.gmail.com>
 <CAGdaadbgEpagiT0hR1nDpSm--TKGUpFLdQikZ_qGkxi_82+BCA@mail.gmail.com>
 <CAD0Gp_aM-pZn=3WKT008eO-_bfOzA1=amniJ8DPZ0+K7=MDKsg@mail.gmail.com> <CAE0An6f5LkjoZU-F6OtNXVo_jWz3XWhS+Zk06vAKZH4aRYDApQ@mail.gmail.com>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Fri, 28 Dec 2012 11:08:04 +0530
Message-ID: <CAD6i1fJWaAOyUgz7mNa_xky2vowP_OQJfnVj1neqWgWUMD22Nw@mail.gmail.com>
Subject: Re: Bad magic number and
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: sham pavman <shampavman.cg@gmail.com>,
        Mulyadi Santosa <mulyadi.santosa@gmail.com>,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 28, 2012 at 10:57 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>
>
> On Thu, Dec 27, 2012 at 8:29 PM, sham pavman <shampavman.cg@gmail.com>
> wrote:
>>
>> I've tried that as well.. and the result is the same.
>> I've little idea on how to start debugging.
>> If you can provide some info it would be great.

Check your mkfs and mount commands. You have specified the whole disk
instead of partition. It should be...

mkfs -t ext4 /dev/sdb1
mount -t ext4 /dev/sdb1 /mnt/test

Regards.
