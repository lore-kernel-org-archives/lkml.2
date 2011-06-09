Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1FIQnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:43:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42788 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1FIQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:43:03 -0400
Message-ID: <4DF0F7F5.5050107@oracle.com>
Date: Thu, 09 Jun 2011 09:42:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        konrad.wilk@oracle.com, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, akpm@kernel.org,
        dsaxena@linaro.org, linux-console@vger.kernel.org, greg@kroah.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com> <201106090938.23027.arnd@arndb.de> <4DF0F5A1.5080008@oracle.com> <4DF0F672.8040206@freescale.com>
In-Reply-To: <4DF0F672.8040206@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DF0F802.0060:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/11 09:36, Timur Tabi wrote:
> Randy Dunlap wrote:
>> But it sounds like virt/ needs virt/host/ and virt/guest/ to me.
> 
> I'm okay with that idea, except there's a consensus that drivers should be in
> drivers/.
> 

Like sound/ ?

but what makes it a "driver"?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
