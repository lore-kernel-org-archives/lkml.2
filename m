Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0EITGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 15:06:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:52679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0EITGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 15:06:30 -0400
Message-ID: <4BE707BB.3060100@suse.de>
Date: Sun, 09 May 2010 21:06:35 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
Cc: kvm-ppc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>, hollis@penguinppc.org
Subject: Re: Keep index within boundaries in kvmppc_44x_emul_tlbwe()
References: <4BE6D437.9000200@gmail.com>
In-Reply-To: <4BE6D437.9000200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> An index of KVM44x_GUEST_TLB_SIZE is already one too large.
>   

Thanks for this one Roel. Please try to keep kvm@vger CC'ed on KVM
patches, as all KVM patches go through kvm.git.

Hollis, I'd like to see an Ack from you on this patch. It looks
reasonable to me, but I'd still feel better if there was some word from
you on it.


Alex

