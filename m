Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab1D2I1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:27:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab1D2I1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kaj76hOj16PIAloD5IY2WCeTOUR/65zbUhCPsSvU7Q7O22koJmPqnwdJ5Spd2138OJ
         KG/xEb6D1bSg+xiuTykPK+0g8gQ/kxFoJLD94MoL1fKrLj3z+aZeJx3b2DF22EiAs6Ew
         VUfGgAJkrzQgRR0l4tgvAzNoMqIBM+ewvAIjA=
Date: Fri, 29 Apr 2011 10:16:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cdrom: always check_disk_change() on open
Message-ID: <20110429081653.GI16552@htj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110429060200.GA5107@amit-x200.redhat.com>
 <4DBA73B6.6040603@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBA73B6.6040603@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:15:50AM +0200, Jens Axboe wrote:
> > Also, please mark this for stable-2.6.38.
> 
> Done, added for 2.6.39 and marked stable for 2.6.38.

Heh, mid-air collision.  Good morning, Jens. :)

-- 
tejun
