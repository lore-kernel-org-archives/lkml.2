Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0LOUte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:49:34 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:51385 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0LOUtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:49:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QitklJoXIpZNymx2UWlmllJz/EPsgFJH5dNku4vDEUlNV5nBj3ZbgrwDv8wBiiIU+I
         wsQJqeqNCs7xPIAcK9Rdvy9llOkgwst79cIMnkIOXXd+mJ9JWyjFKCwqCrS8wm+4tFbj
         esgBSYQuSJh3EYaJgYmRKnITSkUkprPorHDcY=
MIME-Version: 1.0
In-Reply-To: <201012152135.35941.PeterHuewe@gmx.de>
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de>
	<201012152135.35941.PeterHuewe@gmx.de>
Date: Wed, 15 Dec 2010 21:49:30 +0100
Message-ID: <AANLkTin+vOvpK4geMKdcx4wiOSc_EdPNwXJAcFTaCcnf@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
From: Corentin Chary <corentin.chary@gmail.com>
To: =?UTF-8?Q?Peter_H=C3=BCwe?= <PeterHuewe@gmx.de>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 9:35 PM, Peter Hüwe <PeterHuewe@gmx.de> wrote:
> Am Donnerstag 09 Dezember 2010, 00:29:30 schrieb Peter Huewe:
>> This patch removes a recursive dependency which causes a build failure
>> [1-3] by changing the ASUS_WMI from select ACPI_WMI to depend on
>> ACPI_WMI as most other _WMI config options do.
>>
>> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Hi, another patch was posted before:

http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/970/match=acpi_wmi

Randy Dunlap sort of Acked it ("Ah, that's what Sedat's patch does.  Good.")
http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/971/match=acpi_wmi

Your patch seems to miss TC1100_WMI section.

-- 
Corentin Chary
http://xf.iksaif.net
