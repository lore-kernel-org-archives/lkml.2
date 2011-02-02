Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1BBWsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:48:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38679 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1BBWsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:48:42 -0500
Message-ID: <4D49DF35.5010608@zytor.com>
Date: Wed, 02 Feb 2011 14:48:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
CC: Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <20110127230013.GO4981@outflux.net> <4D4228CE.5090601@zytor.com> <4D423A19.2060201@zytor.com> <4D42F5C8.8060703@goop.org>
In-Reply-To: <4D42F5C8.8060703@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 08:58 AM, Jeremy Fitzhardinge wrote:
> On 01/27/2011 07:38 PM, H. Peter Anvin wrote:
>> [Adding Jeremy]
>>
>> Jeremy, would this break Xen?  As far as I know, Xen is the main user
>> of skipping segment register initialization.
> 
> Xen doesn't go through head_*.S at all.
> 

OK, I guess it's actually lguest which needs this feature?

	-hpa
