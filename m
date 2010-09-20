Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0ITJbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:31:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59429 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab0ITJbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mcf5L5WnvDwVCuqUD1HzzHAnlUQXKecamzK/xO8MR2DrbfQnw83/F6PBGtpWWR+Z8K
         N+0p6V2qtE6aNGqTU6PXafnd3kdJldvpj+vkPM5FlJM93REFNTxDOIanzjZfRv1DHC6o
         rGO68otgPAzD3hr4KGQg/2nAxu9yPEUoXr4r4=
Message-ID: <4C9729D7.70500@gmail.com>
Date: Mon, 20 Sep 2010 11:31:03 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pedro Francisco <pedrogfrancisco@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ahci rmmodable and shouldn't
References: <201009162256.04765.pedrogfrancisco@gmail.com> <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net> <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2> <4C9602E4.4090007@gmail.com> <1284974726.11757.9.camel@sundae-v2>
In-Reply-To: <1284974726.11757.9.camel@sundae-v2>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/20/2010 11:25 AM, Pedro Francisco wrote:
> Discomfort? Not really, sorry if my stubbornness felt like it. No, I'm
> fine with it.

:-)

> I just thought it was weird the change of behaviour from 2.6.32, plus
> felt that the "Used by" field by lsmod was incorrectly set at 0 since
> the module is, in fact, being used (e)

Hmmm... I don't recall the behavior changing from 2.6.32.  Maybe I've
been just speaking bullshit this whole time.  Can you please post the
output of lsmod?  Maybe the difference is caused by the split between
libahci and ahci?

Thanks.

-- 
tejun
