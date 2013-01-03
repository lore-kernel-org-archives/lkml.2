Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3ACRm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:42:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36267 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3ACRmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:42:24 -0500
Message-ID: <50E5C2E1.3070103@zytor.com>
Date: Thu, 03 Jan 2013 09:41:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Steve Langasek <steve.langasek@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org> <1357219085-4312-2-git-send-email-matt@console-pimps.org>
In-Reply-To: <1357219085-4312-2-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 05:18 AM, Matt Fleming wrote:
>
> A machine's EFI facilities are naturally represented by a bitfield.
>

Nitpick: what you have here is a bitmask, not a bitfield.  This is good, 
because bitfields are generally frowned upon in a Linux kernel context, 
but you may want to revise the description.

Other than that, looks good to me.

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa (who is still on vacation)

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

