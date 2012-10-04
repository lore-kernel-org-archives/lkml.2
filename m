Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946561Ab2JDVcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:32:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47673 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946462Ab2JDVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <16287303.8DVGGcjq5E@vostro.rjw.lan>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<1349305214-3241-1-git-send-email-yinghai@kernel.org>
	<16287303.8DVGGcjq5E@vostro.rjw.lan>
Date: Thu, 4 Oct 2012 14:31:46 -0700
X-Google-Sender-Auth: OLFFD9GdUA4ulL3ABl6Wn3CozrA
Message-ID: <CAE9FiQU=h8mchDHCQ31U-UpPhqmFiO_H5yX2uonsyOh3tK9DYA@mail.gmail.com>
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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

On Thu, Oct 4, 2012 at 2:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> At last we could remove all acpi_bus_start workaround.
>
> Do I understand correctly that you just want to prevent acpi_pci_root_driver
> from binding to the host bridge's struct acpi_device created while we're
> walking the ACPI namespace?

yes, during hot add path.

Yinghai
