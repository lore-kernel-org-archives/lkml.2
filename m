Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1AEDUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:20:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18181 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1AEDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:20:10 -0500
Message-ID: <4D23E315.9060900@oracle.com>
Date: Wed, 05 Jan 2011 11:18:45 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: declare MODULE_FIRMWARE in libsas
References: <4D22CF9F.1070005@oracle.com> <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org>
In-Reply-To: <4D235CAC.5070309@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik 写道:
> On 01/04/2011 09:08 AM, James Bottomley wrote:
>> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>
>>> ---
>>
>> Description?  Since libsas has no firmware, surely some explanation is
>> required.
>
> Indeed.  Looks bogus at first glance?
>
>
I was finding all requested but not exported firmware in scsi driver for 
generating dump initrd use.
In sas_scsi_host.c, request_firmware is called with "sas_addr", sas_addr 
neither builtin nor exported. Don't sas_addr a firmware? Please correct 
me. thanks

