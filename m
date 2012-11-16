Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2KPEdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:33:49 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45325 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2KPEdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:33:46 -0500
Message-ID: <50A5C226.1010902@pobox.com>
Date: Thu, 15 Nov 2012 23:33:42 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Subject: Re: [patch,v3 06/10] ata: use scsi_host_alloc_node
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com> <1352488687-19935-7-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1352488687-19935-7-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 02:18 PM, Jeff Moyer wrote:
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>   drivers/ata/libata-scsi.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>



