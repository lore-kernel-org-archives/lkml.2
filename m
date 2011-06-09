Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1FIQdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:33:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52806 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1FIQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:33:14 -0400
Message-ID: <4DF0F5A1.5080008@oracle.com>
Date: Thu, 09 Jun 2011 09:32:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@lists.ozlabs.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Timur Tabi <timur@freescale.com>, konrad.wilk@oracle.com,
        kumar.gala@freescale.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, akpm@kernel.org, dsaxena@linaro.org,
        linux-console@vger.kernel.org, greg@kroah.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com> <201106090938.23027.arnd@arndb.de>
In-Reply-To: <201106090938.23027.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DF0F5B2.0075:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/11 00:38, Arnd Bergmann wrote:
> On Thursday 09 June 2011 01:10:09 Randy Dunlap wrote:
>> On Wed, 8 Jun 2011 17:45:54 -0500 Timur Tabi wrote:
>>
>>> Add the drivers/virt directory, which houses drivers that support
>>> virtualization environments, and add the Freescale hypervisor management
>>> driver.
>>
>> It can't go in linux/virt or linux/virt/fsl instead?  why drivers/ ?
>>
>> or maybe linux/virt should be drivers/virt ?
> 
> See discussion for v2 of this patch. I suggested that drivers/firmware and virt/
> as options, the counterarguments were that drivers/firmware is for passive
> firmware as opposed to firmware that acts as a hypervisor, and that virt/ is
> for the host side of hypervisors like kvm, not for guests.

OK, I read that thread.  Didn't see a real consensus there.

If you were not the drivers/misc/ maintainer, would you mind if this
driver lived in drivers/misc/?  I wouldn't.

But it sounds like virt/ needs virt/host/ and virt/guest/ to me.


> The driver in here most closely resembles the xen dom0 model, where a
> priviledged guest controls other guests, but unlike xen there is a single
> driver file, so there is no need to have drivers/fsl-hv directory just
> for this one file. We do have a number of other hypervisors that fit in the
> same category, so they can be added here later.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
