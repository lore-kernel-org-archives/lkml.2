Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1ISXvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:51:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42995 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1ISXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <108743536.474964.1316449188347.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <1316359225-2224-1-git-send-email-linkinjeon@gmail.com>
	<108743536.474964.1316449188347.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Tue, 20 Sep 2011 08:51:04 +0900
Message-ID: <CAKYAXd9Q99BSrAfLDe+DK4cYyz7K5JLGvcMnSsE6pSrkEpOTjQ@mail.gmail.com>
Subject: Re: [PATCH] mmc : export hw reset function info to user
From: NamJae Jeon <linkinjeon@gmail.com>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/20 Andrei Warkentin <awarkentin@vmware.com>:
> Hi Namjae, others,
>
> ----- Original Message -----
>> From: "Namjae Jeon" <linkinjeon@gmail.com>
>> To: cjb@laptop.org, linux-mmc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org, "Namjae Jeon" <linkinjeon@gmail.com>
>> Sent: Sunday, September 18, 2011 11:20:25 AM
>> Subject: [PATCH] mmc : export hw reset function info to user
>>
>> user app should know whether hw reset function is enable to use it.
>> so I try to add sysfs file of hw reset function like enhanced area.
>>
>
> If we're going to be adding a bunch of attributes from ext_csd, why not
> just allow dumping the entire ext_csd in a semi-readable form? Via something like
> hex_dump_to_buffer. This will allow easy human an machine parsing, and be more
> lightweight then adding a sysfs attr for each EXT_CSD byte (of which there are a lot).
>
> I'm basing this on the thought that the only clients of these attrbutes would
> either be developers or engineers involved with MMC media, or very specialized
> software.
>
> Thoughts?
>
> A
>

Hi. Andrei.

We can see all dump of ext_csd by using debugfs like this.

mount -t debugfs /dev/mmcblk0 /mnt/
cat /mnt/mmc0/mmc0\:0001/ext_csd

If user take care of it by showing all dump of ext_csd, we may be
comfortable more without having to worry.
But most of them that they do not know a lot of information.
If we provide some information they need them user friendly, I think
that user can use more easily mmc.

Thanks.
