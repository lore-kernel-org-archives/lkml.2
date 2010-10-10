Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0JJMcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0JJMcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:32:52 -0400
Date: Sun, 10 Oct 2010 14:32:20 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 08/12] Handle async PF in a guest.
Message-ID: <20101010123220.GN2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-9-git-send-email-gleb@redhat.com>
 <4CADC6C3.3040305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CADC6C3.3040305@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 03:10:27PM +0200, Avi Kivity wrote:
>  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >When async PF capability is detected hook up special page fault handler
> >that will handle async page fault events and bypass other page faults to
> >regular page fault handler. Also add async PF handling to nested SVM
> >emulation. Async PF always generates exit to L1 where vcpu thread will
> >be scheduled out until page is available.
> >
> 
> Please separate guest and host changes.
> 
Hmm. There are only guest changes here as far as I can see.

--
			Gleb.
