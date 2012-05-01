Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab2EAMyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab2EAMyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:54:40 -0400
Message-ID: <4F9FDD01.8090201@redhat.com>
Date: Tue, 01 May 2012 15:54:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
References: <20120430143902.GA10181@redhat.com>
In-Reply-To: <20120430143902.GA10181@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 05:39 PM, Michael S. Tsirkin wrote:
> cpuid eax should return the max leaf so that
> guests can find out the valid range.
> This matches Xen et al.
>
> Tested using -cpu host.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c |    2 +-

Documentation/virtual/kvm/cpuid.c |  ++++

-- 
error compiling committee.c: too many arguments to function

