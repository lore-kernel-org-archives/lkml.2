Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634Ab2JDPPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:15:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590Ab2JDPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACJDEmoeD+XwjGnA2WwkeJ5TrsaXfgw+mZHPDcX0+7QZ9_80SA@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<1349305214-3241-1-git-send-email-yinghai@kernel.org>
	<1349305214-3241-2-git-send-email-yinghai@kernel.org>
	<CACJDEmoeD+XwjGnA2WwkeJ5TrsaXfgw+mZHPDcX0+7QZ9_80SA@mail.gmail.com>
Date: Thu, 4 Oct 2012 08:15:44 -0700
X-Google-Sender-Auth: kAGASxAc7zlh1xJm_sSYS4-9Jd4
Message-ID: <CAE9FiQVFY1M65smht2vkAAR3nvH+SMUe2NteBvUyZzqabARV2Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] ACPI: add drivers_autoprobe in struct acpi_device
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 6:03 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> On Wed, Oct 3, 2012 at 7:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> To use to control the delay attach driver for acpi_device.
>
> <blinks>
> I am not sure what this says. Can you please explain how it controls
> the delaying of
> attaching drivers?
>>
>> Will use bus notifier to toggle this bits when needed.
>
> Will use ..? In a subsequent patch? Which patch? And when is this
> needed? Is there a patch that needs this?

please check patch 0-4 as a whole.

Yinghai
