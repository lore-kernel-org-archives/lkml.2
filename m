Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab0JTF6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:58:55 -0400
Received: from mail.perches.com ([173.55.12.10]:3177 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab0JTF6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:58:53 -0400
Subject: Re: [PATCH] Add Intel GMA500(Poulsbo) Stub Driver
From: Joe Perches <joe@perches.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dri-devel@lists.freedesktop.org, randy.dunlap@oracle.com,
        mjg59@srcf.ucam.org, gregkh@suse.de, trenn@suse.de,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de, airlied@linux.ie,
        airlied@redhat.com, eric@anholt.net, alexdeucher@gmail.com,
        bskeggs@redhat.com, chris@chris-wilson.co.uk,
        "Lee, Chun-Yi" <jlee@novell.com>
In-Reply-To: <1287553879-25897-1-git-send-email-jlee@novell.com>
References: <1287553879-25897-1-git-send-email-jlee@novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 22:58:51 -0700
Message-ID: <1287554331.1813.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 13:51 +0800, Lee, Chun-Yi wrote:
> Currently, there have no GMA500(Poulsbo) native video driver to support
> intel opregion. So, use this stub driver to enable the acpi backlight
> control sysfs entry files by requrest acpi_video_register.
[]
> diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
[]
> +static struct pci_device_id pciidlist[] = {

DEFINE_PCI_DEVICE_TABLE
 

