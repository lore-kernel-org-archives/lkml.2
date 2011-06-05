Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1FEJHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:07:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46668 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab1FEJHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qAjqr/w/1SiOwYsGP1fvcfya1VcWmwnOyPMkwPbh/RJT1hA2FLSMVeWUN5NaE3L2VV
         l7o9EyFRnzUpH7N+eaoVJtISKpra/ZpGzL2pjcDy7+n4a0jBx9czrnE6OPN28KK5O2Us
         9//KfPryTaigKsh43JzRMRLtay9X7Ey5L+q1s=
Message-ID: <4DEB4759.3070403@gmail.com>
Date: Sun, 05 Jun 2011 11:07:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, stable@kernel.org
Subject: magicmouse regression [was: Linux 2.6.39.1]
References: <201106032246.25979.edt@aei.ca>
In-Reply-To: <201106032246.25979.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing some people.

On 06/04/2011 04:46 AM, Ed Tomlinson wrote:
> On Thursday 02 June 2011 20:38:35 you wrote:
>> I'm announcing the release of the 2.6.39.1 kernel.
>>
>> All users of the 2.6.39 kernel series must upgrade.
>>
>> The updated 2.6.39.y git tree can be found at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.39.y.git
>> and can be browsed at the normal kernel.org git web browser:
>>          http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=summary
>>
>
> Greg,
>
> Just updated to 39.1 and it breaks my magicmouse
>
> [  107.360715] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4.4/2-4.4:1.0/bluetooth/hci0/hci0:21/input8
> [  107.376797] magicmouse 0005:05AC:030D.0005: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:02:72:20:20:1D
> [  107.423387] magicmouse 0005:05AC:030D.0005: unable to request touch data (2)
> [  107.451216] magicmouse: probe of 0005:05AC:030D.0005 failed with error 2
>
> and the magicmouse is dead.
>
> reverting 23746a66d7d9e73402c68ef00d708796b97ebd72
>
> makes it work as before.


-- 
js
