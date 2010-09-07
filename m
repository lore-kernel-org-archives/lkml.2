Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0IGGym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:54:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0IGGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ng9RR/18hSn36kgomT8wbCYJAhNkm2UxNlz5Oti3ShWZrk8v338+hwYIuigrLG9LgP
         r+iviZSEj8/GDfcj6XqpsSFTESqftIj0QFMRyzsZyEzzzontmYjN2tinmfDQSUCnaWiH
         Kdm7od2Oi1V703TjDL4nf2XWTF4pr5Aus9JhM=
Message-ID: <4C85E1A7.2010906@gmail.com>
Date: Tue, 07 Sep 2010 08:54:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <4C7EB3A3.7050402@gmail.com> <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu> <20100906194838.GB31384@core.coreip.homeip.net> <4C855BAA.4000900@gmail.com> <20100906233203.GA18048@seas.upenn.edu>
In-Reply-To: <20100906233203.GA18048@seas.upenn.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 01:32 AM, Rafi Rubin wrote:
> On Mon, Sep 06, 2010 at 11:22:50PM +0200, Jiri Slaby wrote:
>>>> +
>>>> +		ret = ntrig_version_string(&data[2], buf);
>>>> +
>>>> +		dev_info(&hdev->dev,
>>>> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
>>>> +			 buf, data[2], data[3], data[4], data[5]);
>>>> +
>>>> +		kfree(buff);
>>
>> In any case, this doesn't compile...
>>
>>>> +	}
> 
> Jiri, I moved the code to a separate function as Dmitry suggested, and compiled a kernel from a clean tree using 
> gcc-3.4 (I think).

This version is OK. In the previous one, there was
char *buf;
...
kfree(buff);

thanks,
-- 
js
