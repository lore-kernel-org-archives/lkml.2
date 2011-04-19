Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1DSFMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 01:12:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44104 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1DSFMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 01:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=j/9D9+wLuulR5Iunr9XwUOVOCEaqsRkfT62QB0Abq56VOGuONsQrOiG1MjtjjhjSr+
         lu4TbPH4rxXL69/PtbkeDDPPJsmegbRIjniZq54HK9XlXsySIAgt6JNxet9KMkbmZoPP
         7TyZoXzy19pAIukgLuM9EeMXI5etT7mQojtv8=
MIME-Version: 1.0
In-Reply-To: <BANLkTingpBu6Xnpd8QdGX7LfUb3UDKj59w@mail.gmail.com>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com> <BANLkTingpBu6Xnpd8QdGX7LfUb3UDKj59w@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 19 Apr 2011 13:11:53 +0800
Message-ID: <BANLkTika_0Xeex3+gsjupBdajSF7BPNPnw@mail.gmail.com>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
To: wanlong.gao@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think so.

I am in x86_32 and x86_64.

Thanks,
Hui

On Tue, Apr 19, 2011 at 11:05, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> On 4/19/11, Hui Zhu <teawater@gmail.com> wrote:
>> Cannot connect to any outside devices through bluetooth.
>>
>> And I think this is not a bug of low level driver.  Because both my
>> laptop and a usb bluetooth card cannot work.
>>
>> Thanks,
>> Hui
> Maybe this patch can fix ?
> http://userweb.kernel.org/~akpm/mmotm/broken-out/bluetooth-fix-build-warnings-on-defconfigs.patch
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
