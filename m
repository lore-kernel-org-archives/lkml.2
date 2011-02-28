Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1B1PsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:48:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39802 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1B1PsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TJ3XxLXlHxYVeINuGA3UCzTqopRGMEpeyZLk9PlOfgKeamVMD4l5SFN0koB/HV6V09
         lLrZTunGaztGo9XiEI8yOm5neYyc5ahIwIpYEgpEWlANm3ms3Ovu6GB5CDqgivT/5y2O
         P89UkRx/PNUBk13HiU8N8YCz9J/1izQEacAqg=
Message-ID: <4D6BC3AE.903@suse.cz>
Date: Mon, 28 Feb 2011 16:47:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz> <20110228145301.GC10846@dumpdata.com>
In-Reply-To: <20110228145301.GC10846@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 03:53 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 28, 2011 at 10:37:02AM +0100, Jiri Slaby wrote:
>> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>> needn't be a physical address in presence of IOMMU. So ensure we are
> 
> Can you add a comment why you are fixing it? Is there a bug report for this?
> Under what conditions did you expose this fault?

No, by a just peer review when I was looking for something completely
different.

> You also might want to mention that "needn't be a physical address as
> a hardware IOMMU can (and most likely) will return a bus address where
> physical != bus address."

Mauro, do you want me to resend this with such an udpate in the changelog?

> Otherwise you can stick 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
> on it.

thanks,
-- 
js
suse labs
