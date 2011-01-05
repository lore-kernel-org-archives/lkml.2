Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1AEEsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:48:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55310 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1AEEsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:48:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZbdPO90Hctf56/k2CisvdQj1knjw45yAyJtjEte9JOiRURXXsiQQM1uDJnquBNq0ib
         8o81DSrBSFbR+DJpyiG79aB8ONn3Tw+gt8UZ8c3Gduak9j6MQO9D4Gq1utu5+SsUr38l
         IN91yOllKoCmO4a1TuQ9xm+C0buQyomXkVfvk=
Date: Wed, 5 Jan 2011 12:47:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: declare MODULE_FIRMWARE in libsas
Message-ID: <20110105044733.GA6256@cr0.nay.redhat.com>
References: <4D22CF9F.1070005@oracle.com>
 <1294150132.4726.0.camel@mulgrave.site>
 <4D235CAC.5070309@garzik.org>
 <4D23E315.9060900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D23E315.9060900@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:18:45AM +0800, DuanZhenzhong wrote:
>Jeff Garzik 写道:
>>On 01/04/2011 09:08 AM, James Bottomley wrote:
>>>On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>>>Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>>
>>>>---
>>>
>>>Description?  Since libsas has no firmware, surely some explanation is
>>>required.
>>
>>Indeed.  Looks bogus at first glance?
>>
>>
>I was finding all requested but not exported firmware in scsi driver
>for generating dump initrd use.
>In sas_scsi_host.c, request_firmware is called with "sas_addr",
>sas_addr neither builtin nor exported. Don't sas_addr a firmware?
>Please correct me. thanks
>

But once you export it, it needs to be found in fireware/ directory...
