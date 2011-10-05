Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab1JEOWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:22:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:55592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab1JEOWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:22:22 -0400
Subject: Re: [PATCH v2 0/9] perf support for x86 guest/host-only bits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu
Date: Wed, 05 Oct 2011 16:22:15 +0200
In-Reply-To: <4E8C604A.5090606@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
	 <4E8C604A.5090606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317824535.6766.31.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 15:48 +0200, Avi Kivity wrote:
> On 10/05/2011 02:01 PM, Gleb Natapov wrote:
> > This patch series consists of Joerg series named "perf support for amd
> > guest/host-only bits v2" [1] rebased to 3.1.0-rc7 and in addition,
> > support for intel cpus for the same functionality.
> >
> 
> Looks good to me.  Peter, Ingo, if it works for you as well, please 
> merge 1-6 into a branch on tip that I can pull and apply the rest on top of.

I queued bits, and they should hopefully find their way to tip:perf/core
soonish.
