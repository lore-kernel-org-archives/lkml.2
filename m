Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0E3Sv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 14:51:27 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:47750 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0E3Sv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 14:51:26 -0400
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 May 2010 14:51:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tnhAbd32VAJ50OwYvlrcHNQ/pZ/TGEzPZ3UbwFBU+BoP2a3w9tffQLVhe6Og5sp7ou
         IqKTj7o0QJcf5XMQFCkRYlTpp3UyFmZB9CZVU/PfEy8yLHfJqEn9yzHiqWq0q+C3V7HX
         vJDA9fBKNjUJw1hY91cEXXH1yUUH0iJCUY7/E=
Message-ID: <4C02B3AB.3040405@gmail.com>
Date: Sun, 30 May 2010 12:51:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
References: <4BFA52C3.4080006@xs4all.nl> <20100526120236.4a849b5b.randy.dunlap@oracle.com> <4C021507.6020703@xs4all.nl>
In-Reply-To: <4C021507.6020703@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 01:34 AM, Udo van den Heuvel wrote:
>
>> Have you enabled ACPI in the BIOS and kernel config? AFAIK, HPET
>> timers, need some backup timers, for HPET to be enabled.
>
> ACPI is enabled. APM is disabled.
>
> Epia LT BIOS is at 1.01 presumably. BIOS update to 1.03  fails as
> vf-1.02.exe, presumably due to freedos, does not recognise the VIA board
> and complains about it.
>
> Also due to board swap last year it can be the case that HPET has so far
> not worked at all on EPIA LT.
>
> The board has VIA C7 CPU and VIA CX700M2 Unified Digital Media IGP
> chipset which supports HPET.
>
> Can it be that the kernel lacks support for CX700 hpet?
> Or is it a matter of getting the BIOS upgrade to work?

Your current BIOS doesn't provide an HPET ACPI table, which is the way 
it's supposed to indicate support. The kernel only supports 
force-enabling HPET on VIA for VT8235 and VT8237.
