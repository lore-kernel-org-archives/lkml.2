Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0K2ScP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:32:15 -0500
Received: from 8bytes.org ([88.198.83.132]:46518 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0K2ScO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:32:14 -0500
Date: Mon, 29 Nov 2010 19:32:12 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Valdis.Kletnieks@vt.edu
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
	Virtualization
Message-ID: <20101129183212.GD15575@8bytes.org>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com> <4CED63DC.20608@redhat.com> <20101125114640.GC6031@amd.com> <20101125131351.GA9382@amd.com> <4CEE7E21.3060007@redhat.com> <20101125162313.GA9411@amd.com> <11557.1291051418@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11557.1291051418@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:23:38PM -0500, Valdis.Kletnieks@vt.edu wrote:
> (Sorry for late reply...)
> 
> On Thu, 25 Nov 2010 17:23:13 +0100, "Roedel, Joerg" said:
> > On Thu, Nov 25, 2010 at 10:17:53AM -0500, Avi Kivity wrote:
> > > On 11/25/2010 03:13 PM, Roedel, Joerg wrote:
> > > What about things like adding instructions and forgetting to add the 
> > > corresponding svm.c code?
> > Cannot happen. Every instruction that can be intercepted with SVM is
> > already handled in this patch-set.
> 
> Call us back when Intel releases the i9 and i11 with new instructions
> that need intercept handling. ;)

How does that affect SVM?

