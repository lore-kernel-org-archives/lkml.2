Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1AKBse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:48:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40188 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1AKBs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:48:27 -0500
Message-ID: <4D2BB684.3090109@kernel.org>
Date: Mon, 10 Jan 2011 17:46:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4]  x86: early_quirk check all dev/func in domain 0
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org> <4D2BAA7B.3030800@kernel.org> <20110111010903.GE32585@kroah.com>
In-Reply-To: <20110111010903.GE32585@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 05:09 PM, Greg KH wrote:
> On Mon, Jan 10, 2011 at 04:55:23PM -0800, Yinghai Lu wrote:
>>
>> go with all buses instead of bus0.
> 
> Why?

in cause USB host controller is not on Bus0.

> 
>> also only check header type on func0.
> 
> Why?

that is bug.

notice when there is 00:1a.0, 00:1a.1, 00:1a.2 00:1a.7

the quirk code will not be applied with 00:1a.2 and 00:1a.7

it will exit after checking 00:1a.1's header type.

> 
> Please be more verbose in your change log comments, it cuts down on
> emails like this one...

sure.

Thanks

Yinghai
