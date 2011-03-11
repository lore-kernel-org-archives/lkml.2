Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1CKWrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:47:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56519 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1CKWrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=AKwOz+iv7wKJMIO7WSaGVaLHIodd707R/B+3IEBGxK0DmkClLQNLEVx5HFD19G3skJ
         r7EfRwLtww/jBMF4jmidXFiSKhsNipkR782bS2nQI1htjjAmerB1K6/epB21i39+ZnPI
         DtGnglqDEEiS+Qi1x/c8GrbEkBbYl/s0DEFMA=
Message-ID: <4D7AA674.2050705@linaro.org>
Date: Fri, 11 Mar 2011 22:47:16 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Andy Green <andy@warmcat.com>, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <AANLkTi=+6cp=F1ZDiH1vFwqvseU-Punwpq99P1j-U4Q1@mail.gmail.com>
In-Reply-To: <AANLkTi=+6cp=F1ZDiH1vFwqvseU-Punwpq99P1j-U4Q1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 10:45 PM, Somebody in the thread at some point said:
> On Fri, Mar 11, 2011 at 2:50 AM, Andy Green<andy@warmcat.com>  wrote:
>> Hi -
>>
>> platform_data is a well established way in Linux to pass configuration data
>> up to on-board assets from a machine file like mach-xyz.c.  It's also
>> supported to pass platform_data up to devices that are probed asynchronously
>> from busses like i2c as well, which is very handy.
>>
>> However AFAIK it's not possible to bind platform_data to probed USB devices
>> as it stands.
>
> Oh, please no.
>
> platform_data is an ugly non-type-checked anonymous pointer.  If you
> need to pass data to a driver, use something better designed.  A
> device tree fragment would work, or provide some kind of query api.
> platform_data is definitely the wrong approach.

$ grep platform_data drivers/* -R | wc -l
2110

-Andy
