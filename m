Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782Ab0HLTEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:04:16 -0400
Received: from 8bytes.org ([88.198.83.132]:40699 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0HLTEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:04:15 -0400
Date: Thu, 12 Aug 2010 21:04:14 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Borislav Petkov <bp@amd64.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
	machines
Message-ID: <20100812190414.GA23755@8bytes.org>
References: <1280940316-7966-1-git-send-email-bp@amd64.org> <1280940316-7966-2-git-send-email-bp@amd64.org> <4C59F24B.1010702@zytor.com> <20100805074503.GI18307@amd.com> <4C5AC736.20903@zytor.com> <20100812144142.GY23755@8bytes.org> <4C64148D.5080305@zytor.com> <20100812170644.GZ23755@8bytes.org> <4C644507.9020606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C644507.9020606@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:01:27PM -0700, H. Peter Anvin wrote:
> On 08/12/2010 10:06 AM, Joerg Roedel wrote:

> > The synchronization problem might be real. The cpu_init function uses
> > per-cpu variables which might not be present in the early synced
> > tramponline page table (iirc). The change to swapper_pg_dir and the
> > global tlb flush should probably be moved to the very beginning of the
> > start_secondary function.
> > 
> 
> Are you going to submit an updated patch, then?

Yes, I will send it next week when I am back in office and gave it some
testing.

	Joerg

