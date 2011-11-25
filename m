Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1KYNKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:10:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab1KYNKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:10:31 -0500
Message-ID: <4ECF93C6.7030304@suse.de>
Date: Fri, 25 Nov 2011 14:10:30 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Petr Uzel <petr.uzel@suse.cz>
Cc: linux-scsi@vger.kernel.org,
        "\"James E.J. Bottomley\" (maintainer:SCSI SUBSYSTEM)" 
	<JBottomley@parallels.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] [SCSI] sd: Adapt comment and printk string after
 renaming sd_attach to sd_probe
References: <1322215365-15655-1-git-send-email-petr.uzel@suse.cz> <1322215365-15655-2-git-send-email-petr.uzel@suse.cz>
In-Reply-To: <1322215365-15655-2-git-send-email-petr.uzel@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 11:02 AM, Petr Uzel wrote:
> Make the comment and printk string match the code.
> 
> Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
