Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0H3RbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:31:19 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:15889 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab0H3RbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:31:18 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Arnd Bergmann <arnd@arndb.de>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: RE: hv block drivers
Thread-Topic: hv block drivers
Thread-Index: AQHLSFHcnkjYB5qn30uR65rFUVBeSJL6onMAgAAOS4D//47G0A==
Date: Mon, 30 Aug 2010 17:31:10 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56224274727@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <201008301643.42253.arnd@arndb.de> <4C7BD9A6.1090108@goop.org>
 <201008301908.51521.arnd@arndb.de>
In-Reply-To: <201008301908.51521.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>On Monday 30 August 2010 Arnd Bergmann wrote: 
>>On Monday 30 August 2010, Jeremy Fitzhardinge wrote:
>> Have you investigated making virtio a scsi device?
>
>I doubt that there is much value in changing it now, and it's not something I'd be interested in working on.
>For the HyperV drivers, it probably makes sense because half of it is trying to look 
>like SCSI anyway, while the other half is trying to look like ATA. For the ATA driver, 
>the obvious choice would be to make it a libata backend, though my impression 
>from a brief look at the driver was that it's better to copy some of the libata code 
>and integrate it into the hv SCSI driver.

Arnd,

Thanks for following up! I was cleaning up some other part of the drivers (not related to IDE/SCSI) 
And on my todo list is to clean up the IDE/SCSI drivers. I will go through the libata code and see
If there is anything in there that I can use to make these drivers somewhat saner.

I am not sure if I can combine them into one yet, Hyper-V treats both drivers differently. And there
Are some rumored changes to Hyper-V that would make these changes maybe even a bit more difficult.

I will use this mailing list to bounce ideas off of. 

I still need to clean up your other suggestion as well, the static declarations :)

For a more general question, When/if we make it out of staging, where should these drivers live?

	drivers/hyper-v or drivers/scsi and drivers/ide.

Is there a standard that is being followed?

Hank.

