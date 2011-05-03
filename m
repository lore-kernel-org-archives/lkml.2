Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1ECVJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:09:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60537 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab1ECVJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o9ZzRQXyLQ4IJqrkiCP8MYKxAcFA4jVYTb5dCtDI85QgmaEJYFoALmgizyUk4MM3wb
         94vnHmx/IJAjQT2rstUbAUY9EvVPUIku8DuSofRKETDdxnns/VYCwqTHpJcFi7Ln8JVo
         urdPFdbc7lQ5QnNQGFeJngMAaZTJkaOZkh6U0=
MIME-Version: 1.0
In-Reply-To: <4DC06BF3.6070208@lwfinger.net>
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net>
 <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 3 May 2011 23:09:19 +0200
Message-ID: <BANLkTim89BHU-0P6TkepLgDBPNfEhiaB-w@mail.gmail.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
        John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/3 Larry Finger <Larry.Finger@lwfinger.net>:
> On 05/03/2011 03:38 PM, Gábor Stefanik wrote:
>>
>> 2011/5/3 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>> On 05/03/2011 03:19 PM, Gábor Stefanik wrote:
>>>>
>>>> On Tue, May 3, 2011 at 6:45 PM, Larry Finger<Larry.Finger@lwfinger.net>
>>>>  wrote:
>>>>>
>>>>> On 05/03/2011 10:59 AM, Walter Goldens wrote:
>>>>>>
>>>>>>> This set of patches introduces a driver for the RTL8192SE PCI
>>>>>>> devices.
>>>>>>
>>>>>> Any estimates on the *SU driver? :)
>>>>>
>>>>> Now that rtl8192se is submitted, I will start work on the driver for
>>>>> the
>>>>> RTL8192DE devices. After that will be the RTL8191SU. It has lower
>>>>> priority
>>>>> because r8712u from staging handles those devices. It is not based on
>>>>> mac80211, but it works.
>>>>
>>>> Again, may I remind you that the preferred behavior in the Linux world
>>>> is release-early, release-often? :-)
>>>
>>> That I know, but "code first" still applies. If the comparison between
>>> rtl8192ce and rtl8192cu has any validity for the rtl8192s varieties,
>>> roughly
>>> half of this driver will be shared. In addition, we do have all the USB
>>> plumbing in place, but we are still talking about a few thousand lines of
>>> code. At last contact, Realtek has no interest in this project, thus I
>>> will
>>> be on my own.
>>>
>>> Larry
>>
>> I do not mean immediately submitting everything for inclusion -
>> however, a publicly accessible Git tree would be nice. A non-rtlwifi,
>> badly coded but functional and GPL-compatible driver is still better
>> than having to use ndiswrapper/load a binary blob.
>
> We are in better shape than having to use ndiswrapper or any non-GPL code.
> The r8712u driver in staging is for the RTL8192SU, and it works perfectly
> well.

What about RTL8192DE?

> It just doesn't use mac80211, which is why it needs to be replaced.
>
> Larry
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
