Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2IDQpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:45:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2IDQpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:45:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120904163829.GA23777@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-11-git-send-email-mjg@redhat.com>
	<CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
	<20120904163829.GA23777@srcf.ucam.org>
Date: Tue, 4 Sep 2012 10:44:59 -0600
Message-ID: <CAKocOOOMevXWCPgAddo4scC+GY+emw67XxC3vFnOtJM81QxkTA@mail.gmail.com>
Subject: Re: [PATCH 10/11] acpi: Ignore acpi_rsdp kernel parameter in a secure
 boot environment
From: Shuah Khan <shuahkhan@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 10:38 AM, Matthew Garrett <mjg@redhat.com> wrote:
> On Tue, Sep 04, 2012 at 10:30:46AM -0600, Shuah Khan wrote:
>> On Tue, Sep 4, 2012 at 9:55 AM, Matthew Garrett <mjg@redhat.com> wrote:
>> > From: Josh Boyer <jwboyer@redhat.com>
>> >
>> > This option allows userspace to pass the RSDP address to the kernel.  This
>> > could potentially be used to circumvent the secure boot trust model.
>> > We ignore the setting if we don't have the CAP_SECURE_FIRMWARE capability.
>>
>> Does this mean, acpi_rsdp is disabled on all current platforms that
>> don't support CAP_SECURE_FIRMWARE?
>
> No, if you're not using secure boot then you'll have
> CAP_SECURE_FIRMWARE.

Gotta say this capability name is confusing. Naming is
CAP_PRE_SECURE_BOOT or something along the lines might be a better
choice. When I just look at this name, I sure thought this
CAP_SECURE_FIRMWARE true means it is a secure boot capable firmware.

-- Shuah
