Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2EANY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:24:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab2EANY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:24:27 -0400
Date: Tue, 1 May 2012 22:24:21 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: update eax documentation in signature cpuid
Message-Id: <20120501222421.d35390564b5fd4d7fbcba76f@gmail.com>
In-Reply-To: <20120501130611.GA8357@redhat.com>
References: <20120501130611.GA8357@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012 16:06:11 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

>  Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
> +The value in eax corresponds to the maximim cpuid function present in this leaf,

maximum?

	Takuya

> +and will be updated if more functions are added in the future.
> +Note also that old hosts set eax value to 0x0. This should
> +be interpreted as if the value was 0x40000001.
>  This function queries the presence of KVM cpuid leafs.
