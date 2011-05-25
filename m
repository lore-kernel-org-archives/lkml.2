Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1EYXlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:41:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60009 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab1EYXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TmISfgWuPghCAzNL/bHo6J2hv+y4pV4Jfc0Elly+QFWKTnWq3uMA+xAX8tZ//yaFox
         XVmAsV/8ESyE93PeF4Iw==
Date: Wed, 25 May 2011 16:40:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
cc: Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
In-Reply-To: <13EBEADFAA5B5041B7FC8A3311E7DD1C044D22F3@XMB-RCD-104.cisco.com>
Message-ID: <alpine.DEB.2.00.1105251639290.29729@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com> <20110525080409.GA16582@infradead.org> <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
 <13EBEADFAA5B5041B7FC8A3311E7DD1C044D22F3@XMB-RCD-104.cisco.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Abhijeet Joglekar (abjoglek) wrote:

> As Roland indicated, the correct fix would be to remove the 
> SLAB_CACHE_DMA flag from the call to kmem_cache, and the GFP_DMA from 
> the call to the mempool allocation routine.
> 
> I can create a patch (attributing the fix to David and Roland) and send 
> out for review. Or if David wants, he can modify the patch he submitted 
> to include this fix. David, please let me know how you want to proceed.
> 

It'd be great if you could create a patch, you would certainly be able to 
speak with more authority on the hardware requirements in the changelog 
than I would :)

Thanks Roland, Christoph, and Abhijeet!
