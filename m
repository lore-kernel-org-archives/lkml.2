Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1HMAXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:23:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42632 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1HMAXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:23:43 -0400
MIME-Version: 1.0
In-Reply-To: <1311957278-12290-1-git-send-email-lacombar@gmail.com>
References: <1311957278-12290-1-git-send-email-lacombar@gmail.com>
Date: Fri, 12 Aug 2011 20:23:42 -0400
Message-ID: <CACqU3MWrPZQL476R5uhOWrkjKNpUqHbX0oX7rB_yYbt8mz0kFQ@mail.gmail.com>
Subject: Re: [PATCH][-next] acpi/acpi_drivers.h: fix warnings when ACPI_DOCK
 is not enabled
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-next@vger.kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Jeff Garzik <jgarzik@redhat.com>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 29, 2011 at 12:34 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> /src/linux/linux/drivers/ata/libata-acpi.c: In function 'ata_acpi_associate':
> /src/linux/linux/drivers/ata/libata-acpi.c:266:11: warning: passing argument 2 of 'register_hotplug_dock_device' discards 'const' qualifier from pointer target type [enabled by default]
> /src/linux/linux/include/acpi/acpi_drivers.h:146:19: note: expected 'struct acpi_dock_ops *' but argument is of type 'const struct acpi_dock_ops *'
> /src/linux/linux/drivers/ata/libata-acpi.c:275:11: warning: passing argument 2 of 'register_hotplug_dock_device' discards 'const' qualifier from pointer target type [enabled by default]
> /src/linux/linux/include/acpi/acpi_drivers.h:146:19: note: expected 'struct acpi_dock_ops *' but argument is of type 'const struct acpi_dock_ops *'
>
ping ? next-20110811 is still bad.

 - Arnaud

> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/acpi/acpi_drivers.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index e49c36d..bb145e4 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -144,7 +144,7 @@ static inline void unregister_dock_notifier(struct notifier_block *nb)
>  {
>  }
>  static inline int register_hotplug_dock_device(acpi_handle handle,
> -                                              struct acpi_dock_ops *ops,
> +                                              const struct acpi_dock_ops *ops,
>                                               void *context)
>  {
>        return -ENODEV;
> --
> 1.7.6.153.g78432
>
>
