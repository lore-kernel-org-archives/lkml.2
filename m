Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1DLFea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:34:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59400 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1DLFe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j9Gsy/2MlHKBlZPBuNQpyBFmQ88KkQGoDZLl8JAGu0xUp8rG3LITjWuHD1Fv1RYEzk
         cZ6+hgRFWV/CvvfTPWN+kyLHtWlH6GLrcXWkgvcmXxrt6FjbA5ieMzWHkW6XRl0LuCiX
         rYJAgP0sBbNhtcQ+7YihARkehEB++yws9Gau4=
Message-ID: <4DA3E45E.3040005@lwfinger.net>
Date: Tue, 12 Apr 2011 00:34:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: RA-Shiang Tu <Shiang_Tu@ralinktech.com>
CC: Walter Goldens <goldenstranger@yahoo.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gwingerde@gmail.com" <gwingerde@gmail.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
References: <4DA33FFD.5070004@gmail.com> <312743.30438.qm@web161611.mail.bf1.yahoo.com> <3CD5C4D3B07007449D2E692F161FEE710933423B@TWHCMBS02.tw.ralinktech.ad>
In-Reply-To: <3CD5C4D3B07007449D2E692F161FEE710933423B@TWHCMBS02.tw.ralinktech.ad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 12:23 AM, RA-Shiang Tu wrote:
> Hi,
>>>> Are there any changelogs for these firmware files? Do
>>> they
>>>> only offer support for newer chips, or are there any
>>> actual
>>>> improvements and bug fixes implemented? Users should
>>> know
>>>> whether updating the firmware will be of any use to
>>> them.
>>>
>>> Shiang Tu from ralink says [1] :
>>> "We always suggest to use latest firmware, because it's backward
>>> compatible and also has some enhancement, bug fix, or
>> support of new
>>> chip.
>>
>> Sorry, but how very ... Microsoft-y of Ralink.
>> Something has changed, a bug, an improvement, but we are to
>> guess what it is?
>> Maybe if people knew how these firmware files affect
>> different generations of chips, they'd knew how to maintain
>> them better. I think this contributes to the mess here.
>>
>
> First of all, thanks for all for the great help to make Ralink chipset can
> work well in Linux.
>
> In deed, restricted by the limited resources, Ralink didn't involve in the
> rt2x00 project development closely for long time and the rt2x00 project
> developers and free contributors only can get limited information from
> Ralink's open source code. I think that' why make the situation becomes
> a little bit complicate. Sorry for that.
>
> Now we try to work closely with rt2x00 project, we also will sumbit latest
> frimware to linux-firmware once have any updates. We are newbie to work
> with open source community, if we have any problem, your kindly help will
> be highly appreciated.

Shiang,

We greatly appreciate the help you have given. We certainly understand the 
problems of limited resources.

Does Ralink have any documentation that you can share regarding the changes in 
rt2860.bin from revision 11, which is now in linux-firmware, to the current 
revision 34. The same information on the changes from revision 12 to revision 29 
of rt2870.bin would also be useful. As you have seen in the E-mails, the details 
are requested for the acceptance of the new versions in linux-firmware.

Thanks,

Larry

