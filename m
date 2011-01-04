Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1ADRpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:45:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62138 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1ADRpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oEvEQKWu7uIF+m5vjbWmjbNYDY2yKQzoy4LTRxp093BqDFUORtCw3f8QhdrZenpMC8
         5ofkYObvIuD7VFaiEumZt0NfJQzfEqfiVM+xLEnaL6FN2+2ni/Aaz4wJX6t3nbwggmh6
         vChCQL3ltSar3kRKaSlEIDb3XxtiCX66u+xrY=
Message-ID: <4D235CAC.5070309@garzik.org>
Date: Tue, 04 Jan 2011 12:45:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: DuanZhenzhong <zhenzhong.duan@oracle.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: declare MODULE_FIRMWARE in libsas
References: <4D22CF9F.1070005@oracle.com> <1294150132.4726.0.camel@mulgrave.site>
In-Reply-To: <1294150132.4726.0.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 09:08 AM, James Bottomley wrote:
> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>
>> ---
>
> Description?  Since libsas has no firmware, surely some explanation is
> required.

Indeed.  Looks bogus at first glance?


