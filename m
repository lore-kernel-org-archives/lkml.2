Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0KXRtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:49:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54369 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0KXRtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:49:53 -0500
Message-ID: <4CED5012.6040808@zytor.com>
Date: Wed, 24 Nov 2010 09:49:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] x86, lib: Add a wbinvd helper for an arbitrary cpu
 set
References: <1290620644-27423-1-git-send-email-bp@amd64.org>
In-Reply-To: <1290620644-27423-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 09:44 AM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a wbinvd helper for an arbitrary set of CPUs.
> 

Are there any expected users of this other than KVM?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

