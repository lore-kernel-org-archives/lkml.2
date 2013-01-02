Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3ABRwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:52:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52446 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3ABRwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:52:39 -0500
Message-ID: <50E473DB.4050504@zytor.com>
Date: Wed, 02 Jan 2013 09:52:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Shea Levy <shea@shealevy.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revisiting EFI boot stub config file support
References: <50E306FB.6080607@shealevy.com> <50E31BB4.7040702@zytor.com> <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com> <20130102174319.GA2590@srcf.ucam.org>
In-Reply-To: <20130102174319.GA2590@srcf.ucam.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 09:43 AM, Matthew Garrett wrote:
> On Wed, Jan 02, 2013 at 08:26:29AM -0500, Shea Levy wrote:
> 
>> Hm, ok. Does the boot stub have access to CONFIG_CMDLINE? Or could 
>> another compile-time setting be added so that distros can ship livecds 
>> that automatically use a config file found at a hard-coded location?
> 
> Just pass the config file as the first argument?
> 

CONFIG_CMDLINE can certainly become available to the stub... it's a
compile-time constant.

	-hpa

