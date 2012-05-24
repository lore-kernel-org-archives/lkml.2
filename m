Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099Ab2EXXY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:24:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45017 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab2EXXYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:24:18 -0400
MIME-Version: 1.0
In-Reply-To: <4FBB8FD0.9050804@redhat.com>
References: <4FBB8FD0.9050804@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 16:23:51 -0700
X-Google-Sender-Auth: EV3MFetHcuQdbItYJR_En8yWGqY
Message-ID: <CA+55aFzWb4Sm2jNStvaORVCGd0AQ_inVwxu+9D9uWNpsOMd_Yg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for Linux 3.5
To: Avi Kivity <avi@redhat.com>, Alan Cox <alan@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 6:08 AM, Avi Kivity <avi@redhat.com> wrote:
> Linus, please pull the KVM updates for the 3.5 cycle from

Ok. The way I resolved a the x86 kvm_para.h conflict, I suspect it is
now being *unnecessarily* careful about doing the CPUID thing, and I
think that the "cpuid_level < 0" check that came in through the x86
tree can be removed in favor of the KVM one.

But I left both checks in as the obvious non-semantic resolution, and
if you guys decide that it's redundant, you can remove it later.

                    Linus
