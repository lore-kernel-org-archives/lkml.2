Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1GSTrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:47:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48638 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751483Ab1GSTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:47:34 -0400
Date: Tue, 19 Jul 2011 15:47:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 27/34] drivers/usb changes for SMBIOS and System Firmware
In-Reply-To: <1310994528-26276-28-git-send-email-prarit@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1107191546460.1895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Prarit Bhargava wrote:

> As part of the new SMBIOS and System Firmware code:
> 
> - Replace old dmi* structures and functions with new sysfw* and smbios*
> structures and functions in individual drivers
> - cleanup sysfw_id lookup tables
> - add exactmatch functionality
> 
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  drivers/usb/host/pci-quirks.c |   19 ++++++++++++++-----
>  drivers/usb/host/uhci-hcd.c   |    2 +-
>  drivers/usb/host/uhci-pci.c   |   15 +++++++++++----
>  3 files changed, 26 insertions(+), 10 deletions(-)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

