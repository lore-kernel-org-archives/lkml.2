Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1ACPKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:10:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57343 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab1ACPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RHZTOiDx1ehUmx0rlD8TfDysabZa1YvrtVsOXlpz/AarbzK5URigUSHTGtlboxzut+
         oF4qCojQ+ByPAX0bcJgirx6lO1O3ERmlkCVj1nwxYeC4s2AUG6WLp23nFMQsDsJQhNes
         jMRlyQV/1LF0yfQMrom967y2ovPfz2RJuFa+g=
Message-ID: <4D21E70B.6000703@gmail.com>
Date: Mon, 03 Jan 2011 07:11:07 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Mauro Carvalho Chehab <maurochehab@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 14/15]include:media:davinci:vpss.h Typo change diable
 to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <1293750484-1161-4-git-send-email-justinmattock@gmail.com> <1293750484-1161-5-git-send-email-justinmattock@gmail.com> <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com> <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293750484-1161-12-git-send-email-justinmattock@gmail.com> <1293750484-1161-13-git-send-email-justinmattock@gmail.com> <1293750484-1161-14-git-send-email-justinmattock@gmail.com> <4D1DAFF5.3090108@gmail.com> <alpine.LNX.2.00.1101031600510.26685@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101031600510.26685@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 07:01 AM, Jiri Kosina wrote:
> On Fri, 31 Dec 2010, Mauro Carvalho Chehab wrote:
>
>> Em 30-12-2010 21:08, Justin P. Mattock escreveu:
>>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>>> is correct or not.
>>>
>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> Applied.
>
>>
>> PS.: Next time, please c/c linux-media ONLY on patches related to media
>> drivers (/drivers/video and the corresponding include files). Having to
>> dig into a series of 15 patches to just actually look on 3 patches
>> is not nice.
>
> Absolutely.
>
> Justin, no kernel developer should be afraid of being CCed. But try to
> avoid really unnecessary spamming (which this was).
>

alright..

Justin P. Mattock
