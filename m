Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab1ALUvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:51:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33700 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab1ALUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:51:18 -0500
Message-ID: <4D2E13C9.7030704@oracle.com>
Date: Wed, 12 Jan 2011 12:49:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH -next] x86/e820: fix build when ACPI is disabled
References: <20110112141822.c29314c4.sfr@canb.auug.org.au> <20110112122014.2d8455d7.randy.dunlap@oracle.com> <201101122135.55567.rjw@sisk.pl>
In-Reply-To: <201101122135.55567.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/11 12:35, Rafael J. Wysocki wrote:
> On Wednesday, January 12, 2011, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix build error when CONFIG_ACPI is not enabled:
>>
>> arch/x86/kernel/e820.c:734: error:implicit declaration of function 'suspend_nvs_register'


> I'd prefer the appended patch (it also should fix the problem indicated by Jiri).
> 
> Does it work for you?

Yes, both build error and warning are fixed.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
