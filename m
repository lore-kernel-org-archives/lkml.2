Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1C2GmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:42:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44930 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1C2GmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UGSriEBCdz9qNEiqNR71vrBCFWOFtdSoaMe2jZmA8Vdiwd+ryMpgIgPipikq2Af5m7
         uoGlI+qDPFbIiCDaHsU/pekI9+KDSyqigR8dEmO2S5kVFerIWK6Lpp3mICev5NQo9Op2
         iAaiv2ks0r2URFEcSIVMWjjK7MwoPTODGld7g=
MIME-Version: 1.0
In-Reply-To: <87d3la4ele.fsf@devron.myhome.or.jp>
References: <20110328103431.GA22323@july>
	<87k4fi4iwq.fsf@devron.myhome.or.jp>
	<AANLkTinGPxxTaCzDUfgK7QX6C-AWim5ZJUub1BgCw4YC@mail.gmail.com>
	<87d3la4ele.fsf@devron.myhome.or.jp>
Date: Tue, 29 Mar 2011 15:42:03 +0900
X-Google-Sender-Auth: BqfLCPJlsXo8bw1i3fdG8iHALRo
Message-ID: <AANLkTinMK8oXEJdYEqjRSfC348xnGx9Fmc8mRXOVN0AZ@mail.gmail.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 3:37 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
>
>>> Again, this ioctl's design is unclear, and seems to be strange. I
>>> wouldn't want to add this before clearing it. Please explain what is
>>> right behavior.
>>
>> Umm it's out of my scope. it's trim design.
>> See also btrfs batched discard support. it's also no consideration as
>> you mentioned.
>>
>> As I know, now xfs, ext4, and btrfs support this fstrim without these concern.
>>
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/9758
>
> I looked at fstrim.c. It is lowlevel tools to just issue FITRIM - it
> doesn't use the result at all.
>
> Um. Honestly I'd like to see more or wait until real user for now,
> instead of providing unclear design.

You can find the testcase xfs251(?)

and it's our our usage. After UMS support finished, execute the trim
command from 0 to MAXINT.
and periodically call the trim FAT partitions.

Thank you,
Kyungmin Park

>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
