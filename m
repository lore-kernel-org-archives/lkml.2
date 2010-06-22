Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0FVQdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:33:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56304 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0FVQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:33:08 -0400
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4C1DCD1A.4010306@redhat.com>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <20100615135530.4565745D@kernel.beaverton.ibm.com>
	 <4C189830.2070300@redhat.com>  <1276701911.6437.16973.camel@nimitz>
	 <1276876156.6437.23323.camel@nimitz>  <4C1DCD1A.4010306@redhat.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 22 Jun 2010 09:32:39 -0700
Message-ID: <1277224359.9782.21.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-20 at 11:11 +0300, Avi Kivity wrote:
> > That changes a few things.  I bet all the contention we were seeing was
> > just from nr_to_scan=0 calls and not from actual shrink operations.
> > Perhaps we should just stop this set after patch 4.
> >    
> 
> At the very least, we should re-measure things. 

Sure.  I'll go back to the folks that found this in the first place and
see how these patches affect the contention we were seeing.

-- Dave

