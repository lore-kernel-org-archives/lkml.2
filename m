Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1ELPJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:09:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47338 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1ELPJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ew4D+qD99yi8zirbQH4P/H7vgL/F/nxtxm4HFJ1sh7b8XiIfkt3wNfBWrUyNO8RIeh
         ONY2EMd/eFnafg09z0w2PsxxKd6dWRpMB66B0c73vQOf4a2hg9PdZyhHi/5d+NxBPWWJ
         XEKZL0z0IaH9EIwGBF2OnAZWt8uAJu5cEBgMQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	<BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	<BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	<BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
Date: Thu, 12 May 2011 23:09:22 +0800
Message-ID: <BANLkTikXHrSbm-6AtNhb3CM0OXRgoXqZGA@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: ttlxzz ccc <boyzccc@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't get my test machine, either:) thank you ~~

On Thu, May 12, 2011 at 10:49 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, May 12, 2011 at 10:33 PM, ttlxzz ccc <boyzccc@gmail.com> wrote:
>> Thanks for Wangcong
>>
>> I have test the kmemleak-test.ko and the result includes no backtrace
>> except fffffffff, too.
>> I'm compling the kernel by make menuconfig. :)
>
> Odd, this looks like a bug, Cc Catalin Marinas <catalin.marinas@arm.com>
>
> I can't reach my test machine right now, I will try this tomorrow.
>
