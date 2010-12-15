Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0LOUvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:51:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24412 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0LOUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:51:52 -0500
Message-ID: <4D092A38.7020407@oracle.com>
Date: Wed, 15 Dec 2010 12:51:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: =?UTF-8?B?UGV0ZXIgSMO8d2U=?= <PeterHuewe@gmx.de>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de>	<201012152135.35941.PeterHuewe@gmx.de> <AANLkTin+vOvpK4geMKdcx4wiOSc_EdPNwXJAcFTaCcnf@mail.gmail.com>
In-Reply-To: <AANLkTin+vOvpK4geMKdcx4wiOSc_EdPNwXJAcFTaCcnf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/10 12:49, Corentin Chary wrote:
> On Wed, Dec 15, 2010 at 9:35 PM, Peter Hüwe <PeterHuewe@gmx.de> wrote:
>> Am Donnerstag 09 Dezember 2010, 00:29:30 schrieb Peter Huewe:
>>> This patch removes a recursive dependency which causes a build failure
>>> [1-3] by changing the ASUS_WMI from select ACPI_WMI to depend on
>>> ACPI_WMI as most other _WMI config options do.
>>>
>>> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Hi, another patch was posted before:
> 
> http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/970/match=acpi_wmi
> 
> Randy Dunlap sort of Acked it ("Ah, that's what Sedat's patch does.  Good.")
> http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/971/match=acpi_wmi

For Matthew:
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> 
> Your patch seems to miss TC1100_WMI section.

Yes, it would be better to do both (all) of them the same way.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
