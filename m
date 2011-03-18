Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab1CRVRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:17:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39609 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab1CRVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=DvEC2sdu2en8t797U1m25JRs50BBXQsb7ZwDHysjj4bhCIzxxQQPBBsOMSywmEIeni
         gmiu6hXIWpGTPnqjIGs8LAO+XIwj12/279I/kAi5MZXwOQ1zdidwvPWXNTBpsOvL7GZ4
         LS1HmTM1eCVCz03Sfao8F2f59CxmHgTK3l4dE=
Message-ID: <4D83CBCF.2060103@linaro.org>
Date: Fri, 18 Mar 2011 21:17:03 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Anders <x0132446@ti.com>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D83A25C.804@ti.com> <20110318182518.GA2271@opensource.wolfsonmicro.com> <4D83BA4F.8050301@linaro.org> <201103182211.36869.arnd@arndb.de>
In-Reply-To: <201103182211.36869.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 09:11 PM, Somebody in the thread at some point said:
> On Friday 18 March 2011, Andy Green wrote:
>> In which case, they are all potential consumers of a MAC "stored in an
>> alternative location and needs to be programmed into the NIC by
>> software" solution, which he also thinks is needed.
>
> Note that there is also of_get_mac_address(), which is meant to
> deal with this exact problem.

Curiously grep finds it in 7 drivers...

Oh it only solves any problem if you are using Open Firmware, like 
almost everything is not using.

I see.

-Andy


