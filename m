Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0GVIj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:39:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rnUCjeKPhBSIvqD5sfCEG+lELDOIcY0/c5ywtFwlQwTUmaXenS739RXXqmZVGjMT5E
         hs4Ygb1fJI0223X7d3Xc1SR1WyxNKF1TO4jicidF0VBKqUBTy+es+uiNm/N2kkOysTYv
         P8ZJeENruunD6oDHkoQpOS/0StoTguD2VaQuw=
Message-ID: <4C4803D4.7050802@gmail.com>
Date: Thu, 22 Jul 2010 10:39:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Neil Brown <neilb@suse.de>, James Bottomley <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: BUG at drivers/scsi/scsi_lib.c:1113
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene> <20100722083609.GA4435@lst.de>
In-Reply-To: <20100722083609.GA4435@lst.de>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 10:36 AM, Christoph Hellwig wrote:
> On Thu, Jul 22, 2010 at 05:37:16PM +1000, Neil Brown wrote:
>> I suspect that problem is that "do_sync" and "do_barriers" in
>> drivers/md/raid1.c are still 'bool' and should now be 'unsigned long'.
>>
>> I'm not sure how wide '_Bool' is, but I'm guess it isn't wide enough.
>>
>> Could you please try changing ever 'bool' in that file to 'unsigned long'
>> and see if that fixes it?
> 
> Yes, that fixes it.

For me too.

-- 
js
