Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2GTOli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:41:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab2GTOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:41:36 -0400
Message-ID: <50096E1E.60709@suse.de>
Date: Fri, 20 Jul 2012 16:41:34 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] aic79xx: NULL dereference in debug code
References: <20120720113057.GC22245@elgon.mountain>
In-Reply-To: <20120720113057.GC22245@elgon.mountain>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 01:30 PM, Dan Carpenter wrote:
> "ahd" can be NULL here and it gets dereferenced inside the call to
> ahd_name().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)


