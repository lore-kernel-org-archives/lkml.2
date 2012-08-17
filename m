Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2HQRcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:32:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61731 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab2HQRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:31:56 -0400
Message-ID: <502E8007.2060103@pobox.com>
Date: Fri, 17 Aug 2012 13:31:51 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Sergei Trofimovich <slyich@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>,
        Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH] libata: acpi: call ata_acpi_gtm during ata port init
 time
References: <1345021692-4666-1-git-send-email-aaron.lu@intel.com>
In-Reply-To: <1345021692-4666-1-git-send-email-aaron.lu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 05:08 AM, Aaron Lu wrote:
> Commit 30dcf76acc695cbd2fa919e294670fe9552e16e7 mistakenly dropped
> the code to get an initial gtm for the IDE channel. This caused the
> following problem for Sergei:
> http://marc.info/?l=linux-kernel&m=134484963618457&w=2
>
> Fix this by adding the call back in ata_acpi_bind_host, and due to
> this, the ata_ap_acpi_handle is modified accordingly.
>
> Reported-by: Sergei Trofimovich <slyich@gmail.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>   drivers/ata/libata-acpi.c | 15 ++++-----------
>   1 file changed, 4 insertions(+), 11 deletions(-)

applied



