Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab1ELOd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:33:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58471 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab1ELOd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M9Nz1It2GiCopF84ZdWYtXcON0THrKQ9C3zUfjoMssyzH/SmS9dw7JBAXcmaUaXeO/
         3Kxxc7or9YA01KegDYnOU3CewJ+mS00YnRDtpd40gWmRnypVqIN0c3o56dSgQbfwC1Pa
         kyYN3Lx+fLIPm1G25AZmyJxihAbmqPPm2k9nU=
MIME-Version: 1.0
In-Reply-To: <BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	<BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
Date: Thu, 12 May 2011 22:33:27 +0800
Message-ID: <BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: ttlxzz ccc <boyzccc@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for Wangcong

I have test the kmemleak-test.ko and the result includes no backtrace
except fffffffff, too.
I'm compling the kernel by make menuconfig. :)

If it still doesn't make sense, please help me again. Thank you.:)

On Thu, May 12, 2011 at 10:18 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, May 12, 2011 at 7:16 PM, Daniel Baluta <daniel.baluta@gmail.com> wrote:
>>
>> Can you please remove your module?
>> I think the memory is leaked at unload time.
>>
>
> No, in kmemleak-test.c we have same examples.
>
> chenxi, I assume you didn't edit the .config manually?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
