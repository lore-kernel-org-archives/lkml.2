Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2EEOqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:46:17 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:63186 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2EEOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:46:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyNVARALGAICBRYLAgIJAwIBAgFFBg0BBQIBAbQkihiBL44TgRgEqSU
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="178468559"
Message-ID: <4FA53D36.8090609@teksavvy.com>
Date: Sat, 05 May 2012 10:46:14 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chris Jones <chrisjones@spin.net.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hard drive detection
References: <20120504185604.3addfd2e@ubuntu> <4FA3D60F.9090601@teksavvy.com> <20120505093000.1d9789dd@ubuntu> <4FA4959F.2000905@teksavvy.com> <20120505140005.19247cd0@ubuntu>
In-Reply-To: <20120505140005.19247cd0@ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-05 12:00 AM, Chris Jones wrote:
> On Fri, 04 May 2012 22:51:11 -0400
> Mark Lord <kernel@teksavvy.com> wrote:
> 
>> On 12-05-04 07:30 PM, Chris Jones wrote:
>> ..
>>> Thanks Mark. That's exactly what I was looking for. And are both
>>> PATA and SATA internal drives both located in drivers/ata?
>> ..
>>
>> Yes.
>> But historically, PATA drives were handled by the original IDE drivers
>> that I worked on in the mid-1990s.  That code is in linux/drivers/ide,
>> but we're trying hard to phase it out.  The code in linux/drivers/ata
>> (aka. "libata") handles nearly all of the same PATA stuff and more.
>>
> 
> Yeah I remember reading something a while back about all the
> IDE/PATA support being migrated to the SATA sets and phasing out the
> legacy IDE stuff.
> 
> So technically, the old IDE sets could be removed with no negative
> effect on a modern system? Correct?

That's how I do it here.  So, yes.

