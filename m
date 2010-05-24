Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0EXNyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 09:54:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30014 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab0EXNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 09:54:16 -0400
Message-ID: <4BFA84EF.7070609@oracle.com>
Date: Mon, 24 May 2010 06:53:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ben Skeggs <bskeggs@redhat.com>,
       dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH -next] nouveau: fix acpi_lid_open undefined
References: <20100522170459.4c89723d.sfr@canb.auug.org.au> <20100523170040.3c4aa87c.randy.dunlap@oracle.com> <20100524125628.GA14278@srcf.ucam.org>
In-Reply-To: <20100524125628.GA14278@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4BFA84F8.017C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/10 05:56, Matthew Garrett wrote:
> On Sun, May 23, 2010 at 05:00:40PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> When CONFIG_ACPI_BUTTON=m (and probably when ACPI_BUTTON is not enabled)
>> and NOUVEAU is built-in (not as a loadable module):
> 
> Won't this result in a behavioural difference? The desirable outcome is 

It could, yes.

> that that configuration be impossible, not for that configuration to 
> build but be buggy.

so nouveau should depend on (or select, if ACPI is enabled) ACPI_BUTTON?


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
