Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0LFTsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:48:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0LFTst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:48:49 -0500
Date: Mon, 6 Dec 2010 17:29:24 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] KVM: SVM: Add clean-bit for interrupt state
Message-ID: <20101206192924.GB13545@amt.cnet>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
 <1291373159-4822-6-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291373159-4822-6-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 11:45:52AM +0100, Joerg Roedel wrote:
> This patch implements the clean-bit for all interrupt
> related state in the vmcb. This corresponds to vmcb offset
> 0x60-0x67.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Don't you have to mark dirty on sync_lapic_to_cr8? 

