Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0GYIB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:01:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:37778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0GYIB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:01:56 -0400
Message-ID: <4C4BEF61.5010203@kernel.org>
Date: Sun, 25 Jul 2010 10:01:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: jeff@garzik.org, ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl>
In-Reply-To: <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 25 Jul 2010 08:01:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing hpa, hi!)
Hello,

On 07/24/2010 08:40 PM, Yuhong Bao wrote:
>> However, 2TiB limit is
>> inherent in the BIOS programming interface and currently the only way
>> to overcome it is using a completely different BIOS interface (EFI,
>> that is).
>
> Nope, look at the Int13 extensions, it already support 64-bit LBA.

Ah, yeah, that sounds much more logical than requiring transition to
EFI.  Does anyone know how wide spread the support for this extension
is in BIOSes?  Do the bootloaders support this?

Thanks.

-- 
tejun
