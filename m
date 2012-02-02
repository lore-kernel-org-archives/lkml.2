Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2BBPnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:43:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab2BBPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:43:14 -0500
Message-ID: <4F2ACB34.6020709@suse.de>
Date: Thu, 02 Feb 2012 18:43:16 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH] scsi : Adding all the definitions of host
 bytes in hostbyte_table
References: <77471C95FAFD844C8CA02DD4F4C5FE2B01034E@SACEXCMBX02-PRD.hq.netapp.com>
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B01034E@SACEXCMBX02-PRD.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 04:27 PM, Moger, Babu wrote:
> Resubmitting it again(Probably last one had some format issues).
> Adding all the definitions of host bytes in hostbyte_table.
>
> Without this patch, scsi_show_result prints hostbyte as invalid
> for statuses that are not defined in hostbyte_table(when scsi logging is enabled).
>
> Look at scsi_print_result function for better understanding.
>
> Signed-off-by: Babu Moger<babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

