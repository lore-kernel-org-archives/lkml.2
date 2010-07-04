Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab0GDP4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 11:56:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46632 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0GDP4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 11:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=NNgSj5XEExxxAIJzr2J0m2ZUk7K62bhpOwfm7NxUmzhBOhYJLIT+B0N9oXiZiMt0HP
         r8L99LHDhHcFPSsxMyqZH/fortr/HgfGccfOSqigW1HRzY8byzWgJD27FMNXiXRscdhQ
         zVh80XbNq8bbOPAeRTlqNLCiU8AGoXYlxLNRg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinaExfjcAFTSvvZV3Hi3nLAa8bDY6mkqBf9WgvM@mail.gmail.com>
References: <cover.1277911345.git.siccegge@cs.fau.de> <e2a294ec1d41f1198f7ffae0e8bed2f67b41bbe8.1277911346.git.siccegge@cs.fau.de> 
	<AANLkTim9icxxarxlcC39tCnnAIwwBOF8l8a68nQy7xHQ@mail.gmail.com> 
	<AANLkTinaExfjcAFTSvvZV3Hi3nLAa8bDY6mkqBf9WgvM@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 4 Jul 2010 23:56:14 +0800
Message-ID: <AANLkTik7lu8SuljHFI17f9hzR6GqxVI2OvdgyEJjn8Hj@mail.gmail.com>
Subject: Re: [PATCH 24/33] Removing dead ARCH_GUMSTIX_ORIG
To: Jaya Kumar <jayakumar.arm@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 7:57 AM, Jaya Kumar <jayakumar.arm@gmail.com> wrote:
> On Thu, Jul 1, 2010 at 12:27 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>> On Thu, Jul 1, 2010 at 12:01 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
>>> ARCH_GUMSTIX_ORIG doesn't exist in Kconfig, therefore removing all
>>> references for it from the source code.
>>>
>>> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>>
>> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>>
>> Cc'ed Jaya Kumar for additional thoughts.
>
> Looks okay to me too. Thanks.
>
> Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
>

Applied.
