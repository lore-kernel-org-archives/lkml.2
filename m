Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab2HQSLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:11:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40797 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2HQSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:11:16 -0400
Message-ID: <502E8940.7040500@pobox.com>
Date: Fri, 17 Aug 2012 14:11:12 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        sshtylyov@mvista.com
Subject: Re: [PATCH v3 2/2] ata: implement MODE SELECT command
References: <1341490701-15348-1-git-send-email-pbonzini@redhat.com> <1341490701-15348-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341490701-15348-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 08:18 AM, Paolo Bonzini wrote:
> The cache_type file in sysfs lets users configure the disk cache in
> write-through or write-back modes.  However, ata disks do not support
> writing to the file because they do not implement the MODE SELECT
> command.
>
> This patch adds a translation from MODE SELECT (for the caching page
> only) to the ATA SET FEATURES command.  The set of changeable parameters
> answered by MODE SENSE is also adjusted accordingly.
>
> Cc: Sergei Shtylyov <sshtylyov@mvista.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	v2->v3: ensure that only the first page of the sg list is
> 	accessed
>
>   drivers/ata/libata-scsi.c |  194 +++++++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 188 insertions(+), 6 deletions(-)

applied 1-2



