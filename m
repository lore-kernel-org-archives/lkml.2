Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1FITyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:54:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18081 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1FITyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=c0QjZU8DaDBoeHo4J8vVjCMRBvgzEejpA/MwppRm218MnI2X7ewYEt8XYq5sLRlTfw
         vx1rcdPeB5yU60E8Ua0w==
Date: Thu, 9 Jun 2011 12:54:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Simplify code by SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN()
 macro usage
In-Reply-To: <20110609182035.GC23592@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1106091251010.11607@chino.kir.corp.google.com>
References: <20110609182035.GC23592@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Daniel Kiper wrote:

> git commit a539f3533b78e39a22723d6d3e1e11b6c14454d9 (mm: add SECTION_ALIGN_UP()
> and SECTION_ALIGN_DOWN() macro) introduced SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN()
> macro. Use those macros to increase code readability.
> 
> This patch applies to Linus' git tree, v3.0-rc2 tag.
> 

 [ This patch would go through the -mm tree so it should always be based 
   on the latest git tree, no need to mention it.  Alternatively, if it 
   was based on something in -mm that isn't in the latest git yet, then
   you only need to append the "-mm" tag to the subject line:
   "[patch -mm]". ]

> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

Acked-by: David Rientjes <rientjes@google.com>
