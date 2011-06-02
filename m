Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1FBNId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:08:33 -0400
Received: from service87.mimecast.com ([94.185.240.25]:35572 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751035Ab1FBNIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:08:32 -0400
Date: Thu, 2 Jun 2011 14:08:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Disable -fconserve-stack on ARM
Message-ID: <20110602130816.GB8343@e102109-lin.cambridge.arm.com>
References: <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
 <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
 <20110526215101.GL24876@n2100.arm.linux.org.uk>
 <20110527083806.GA21100@e102109-lin.cambridge.arm.com>
 <20110527085414.GP24876@n2100.arm.linux.org.uk>
 <20110527095111.GC21100@e102109-lin.cambridge.arm.com>
 <yw1xlixse2fl.fsf@unicorn.mansr.com>
 <20110528153417.GB25869@alboin.amr.corp.intel.com>
 <20110531163026.GB771@e102109-lin.cambridge.arm.com>
 <20110531180107.GA9261@alboin.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <20110531180107.GA9261@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jun 2011 13:08:46.0619 (UTC) FILETIME=[34DBB6B0:01CC2126]
X-MC-Unique: 111060214082703601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:01:07PM +0100, Andi Kleen wrote:
> Disable -fconserve-stack on ARM v2
> 
> There are reports that -fconserve-stack misaligns variables on the stack.
> Disable it for ARM to work around this gcc bug.
> 
> v2: Move top level flags definition up
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

It seems to disable the -fconserve-stack on ARM.

Tested-by: Catalin Marinas <catalin.marinas@arm.com>

