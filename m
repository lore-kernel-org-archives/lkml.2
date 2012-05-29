Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2E2Mcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:32:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62586 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2E2Mcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120528105428.689d0102@pyramind.ukuu.org.uk>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<20120528104438.044ae385@pyramind.ukuu.org.uk>
	<20120528105428.689d0102@pyramind.ukuu.org.uk>
Date: Tue, 29 May 2012 20:32:49 +0800
X-Google-Sender-Auth: iGytR61fDNbcJfOMkw6E463oGtM
Message-ID: <CAF1ivSaYo8bcYAJ0i1b44HTarz11gndUU_pG109sGPOaupDi3w@mail.gmail.com>
Subject: Re: [PATCH v4 0/13] SATA ZPODD support
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 5:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Have you fixed the fact that Matthews patches broke things like pata_acpi
>> last time ? Until that is fixed properly I don't see that these patches
>> can make any progress.
>
> https://lkml.org/lkml/2012/2/24/2

Aaron has a fix.
We'll do more test.

Thanks for the info.
Lin Ming
