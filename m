Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1ATHWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:22:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1ATHWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:22:30 -0500
Message-ID: <4D37E452.7030404@suse.de>
Date: Thu, 20 Jan 2011 08:29:22 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: Re: [PATCH 08/17][trivial] scsi: Remove unnecessary casts of void
 ptr returning alloc function return values
References: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net> <alpine.LNX.2.00.1101191526410.26685@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101191526410.26685@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 03:27 PM, Jiri Kosina wrote:
> On Tue, 9 Nov 2010, Jesper Juhl wrote:
> 
>> Hi,
>>
>> The [vk][cmz]alloc(_node) family of functions return void pointers which
>> it's completely unnecessary/pointless to cast to other pointer types since
>> that happens implicitly.
>>
>> This patch removes such casts from drivers/scsi/
>>
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>\
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
