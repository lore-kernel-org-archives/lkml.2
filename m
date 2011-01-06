Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1AFQn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:43:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1AFQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:43:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w2MSDC8jfDQLF5dzQuOf0Mxux0IUC9364THAcm/Jd9Wd3rgJXMnas0PxkKLThErfOM
         Ts4RxtlKAfH/4ILfxsCXCej0PhNCkILd5BpXOMXS6Be/d4vIymSoXis1wtMIIKC77YLZ
         sbmhCgmwAs1DxoaS+2lZDeQw0r07Kq80eZrEQ=
Message-ID: <4D25ED22.3070900@gmail.com>
Date: Thu, 06 Jan 2011 17:26:10 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
References: <4D25AEEE.1050401@gmail.com> <1294322613.2016.333.camel@laptop>
In-Reply-To: <1294322613.2016.333.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/01/2011 15:03, Peter Zijlstra ha scritto:
> On Thu, 2011-01-06 at 13:00 +0100, Marco Stornelli wrote:
>> Hi all,
>>
>> after several reviews is time to submit the code for mainline. Thanks to
>> CELF to believe and support actively the project and thanks to Tim Bird.
> 
> Tony Luck was also playing with something like this I believe.
> 

Yes, I know. Even if the approach is different. He is trying to use a
persistent space record-based and with a simple fs interface to store
oops or something like this. The idea here is a little bit different,
i.e. to have a place (a generic piece of memory) to write not sensible
and temporary information with a complete fs structure. However we are
on the same road :)

Marco
