Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1KPMM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:12:26 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40394 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756452Ab1KPMMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:12:25 -0500
Date: Wed, 16 Nov 2011 12:12:07 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Victor Kamensky <kamensky@cisco.com>
Cc: David Daney <david.daney@cavium.com>,
        "manesoni@cisco.com" <manesoni@cisco.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/4] MIPS Kprobes: Deny probes on ll/sc instructions
Message-ID: <20111116121207.GA5079@linux-mips.org>
References: <20111108170336.GA16526@cisco.com>
 <20111108170535.GC16526@cisco.com>
 <4EB98A8E.4060900@cavium.com>
 <Pine.GSO.4.58.1111081504560.10959@infra-view9.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.58.1111081504560.10959@infra-view9.cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 03:26:42PM -0800, Victor Kamensky wrote:

> > s/insturctions/instructions/
> >
> > Not only is it a bad idea, it will probably make them fail 100% of the time.
> >
> > It is also an equally bad idea to place a probe between any LL and SC
> > instructions.  How do you prevent that?
> 
> As per below code comment we don't prevent that. There is no way to do
> that.

Similar to the way that the addresses of loads and stores from userspace
are recorded in a special section we could build a list of forbidden
address range.

Is it worth it?

  Ralf
