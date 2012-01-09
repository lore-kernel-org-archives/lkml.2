Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab2AIWeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:34:17 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54636 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2AIWeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:34:14 -0500
X-Originating-IP: 217.70.178.148
X-Originating-IP: 86.186.9.152
From: Andrzej Prochyra <andrzej@prochyra.name>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Seth Forshee <seth.forshee@canonical.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
References: <20120105150832.GA25386@ubuntu-macmini>
	<1325945558-4661-1-git-send-email-corentincj@iksaif.net>
	<CANq1E4QGahjrxm5B59HGnrfO3LP4kV6bc27BKQDvnJ4HBKAFMg@mail.gmail.com>
Date: Mon, 09 Jan 2012 22:34:06 +0000
In-Reply-To: <CANq1E4QGahjrxm5B59HGnrfO3LP4kV6bc27BKQDvnJ4HBKAFMg@mail.gmail.com>
	(David Herrmann's message of "Mon, 9 Jan 2012 17:39:43 +0100")
Message-ID: <878vlgjyjl.fsf@prochyra.name>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Herrmann <dh.herrmann@googlemail.com> writes:
> On Sat, Jan 7, 2012 at 3:12 PM, Corentin Chary <corentincj@iksaif.net> wrote:
>> On these laptops, the ACPI video is not functional, and very unlikely
>> to be fixed by the vendor. Note that intel_backlight works for some
>> of these laptops, and the backlight from samsung-laptop always work.
>>
>> The good news is that newer laptops have functional ACPI video device
>> and won't end up growing this list.
>>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>> ---
>>
>> Could the concerned people test this patch and check that it correctly
>> disable the acpi_video backlight ?
>
> Works like a charm on my N210 with linux-3.2. Feel free to add a:
> Tested-by: David Herrmann <dh.herrmann@googlemail.com>
>
> I will talk to the intel drm developers about the intel_backlight
> issues as they don't seem related to this driver.

I can confirm on my N150 Plus.  Now only 'intel_backlight' is created
and exhibits the aforementioned issues.

-- 
Andrzej Prochyra
<andrzej@prochyra.name>
