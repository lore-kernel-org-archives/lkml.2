Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab2JCP5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:57:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40945 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932472Ab2JCP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:57:39 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18mzXQiD5cmMfZG2r6x09/xy1oUMv9WbXMrXBiYmo
	rR2IMXvgZ3DJuN
Message-ID: <506C6065.3070202@gmx.net>
Date: Wed, 03 Oct 2012 17:57:25 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com, lenb@kernel.org
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <50158321.4030007@gmx.net> <201208022340.16948.rjw@sisk.pl> <5055DFB6.6070809@gmx.net> <201209182342.30244.rjw@sisk.pl>
In-Reply-To: <201209182342.30244.rjw@sisk.pl>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/12 23:42, Rafael J. Wysocki wrote:
> Hi,
> 
> On Sunday, September 16, 2012, Witold Szczeponik wrote:
>> Hi Rafael, 
>>
>> what about the patches 1 and 3 which do not make any changes to the ABI?
>> The first patch simplifies the code, while the third patch fixes a problem in
>> the PNP resource allocation.  Any chances to have them included in 3.7?
> 
> They would be fine as far as I'm concerned, but I'm not maintaining that part
> of the kernel (at least at the moment).
> 
> I'm not sure who's the maintainer of it, to be honest.

According to the maintainer list, this would be Len and Bjorn.  
Hence...


Len and Bjorn, 

any chances to include the patches in 3.7?  I checked them 
against 3.6 and they applied without any change.  Or should 
I resend them individually? 

Thanks. 

--- Witold

> 
> Thanks,
> Rafael
> 
