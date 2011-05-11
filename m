Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1EKW27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:28:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27352 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1EKW2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wZFoRDj+enM7BSb7aDTiLvdTLhZC2KOLcmQPAD78jeCrUvCHkaYTNWxmwnlbiAuFAf
         zgphEHpBmtlUgv3G6X3g==
Date: Wed, 11 May 2011 15:28:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce impact to overall system of SLUB using
 high-order allocations
In-Reply-To: <1305149960.2606.53.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105111527490.24003@chino.kir.corp.google.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305149960.2606.53.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011, James Bottomley wrote:

> OK, I confirm that I can't seem to break this one.  No hangs visible,
> even when loading up the system with firefox, evolution, the usual
> massive untar, X and even a distribution upgrade.
> 
> You can add my tested-by
> 

Your system still hangs with patches 1 and 2 only?
