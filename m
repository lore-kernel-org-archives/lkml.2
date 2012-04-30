Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2D3SX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:23:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab2D3SX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:23:27 -0400
Message-ID: <4F9ED890.5060601@zytor.com>
Date: Mon, 30 Apr 2012 11:23:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
References: <20120430143902.GA10181@redhat.com>
In-Reply-To: <20120430143902.GA10181@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 07:39 AM, Michael S. Tsirkin wrote:
> cpuid eax should return the max leaf so that
> guests can find out the valid range.
> This matches Xen et al.

Not to mention it's what all the "real" CPU leaf chunks do.

Acked-by: H. Peter Anvin <hpa@zytor.com>

