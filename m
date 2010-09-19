Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0ISNfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 09:35:17 -0400
Received: from daytona.panasas.com ([67.152.220.89]:50071 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753732Ab0ISNfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 09:35:15 -0400
Message-ID: <4C96118F.8080909@panasas.com>
Date: Sun, 19 Sep 2010 15:35:11 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH v2 1/2] tcm: Add support for BIDI-COMMANDS and XDWRITE_READ_10
 emulation
References: <1284590512-6233-1-git-send-email-nab@linux-iscsi.org> <4C961044.3010500@panasas.com>
In-Reply-To: <4C961044.3010500@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2010 13:35:14.0213 (UTC) FILETIME=[7D635550:01CB57FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2010 03:29 PM, Boaz Harrosh wrote:
> On 09/16/2010 12:41 AM, Nicholas A. Bellinger wrote:
>>  		/* Fall through for DMA_TO_DEVICE */
>>  	case DMA_NONE:
>>  		CMD_TFO(cmd)->queue_status(cmd);
>> @@ -6347,6 +6460,23 @@ static inline void transport_free_pages(struct se_cmd *cmd)
>>  		kmem_cache_free(se_mem_cache, se_mem);
>>  	}
>>  
> 
> Again the request for an update tree. (Might be missing some code here)
> 
> The above does a break; in bidi case, but are you freeing this here regardless?
> 

Scratch this out stupid me. That's in another function. Rrrr I need my coffee now

Boaz
