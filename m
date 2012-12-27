Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2L0EBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 23:01:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52368 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2L0EBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 23:01:16 -0500
Message-ID: <50DBC7E8.8040302@zytor.com>
Date: Wed, 26 Dec 2012 20:00:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: andrew.cooper3@citrix.com, ebiederm@xmission.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, maxim.uvarov@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v3 06/11] x86/xen: Add i386 kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com> <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com> <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com> <1356574740-6806-4-git-send-email-daniel.kiper@oracle.com> <1356574740-6806-5-git-send-email-daniel.kiper@oracle.com> <1356574740-6806-6-git-send-email-daniel.kiper@oracle.com> <1356574740-6806-7-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1356574740-6806-7-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 06:18 PM, Daniel Kiper wrote:
> Add i386 kexec/kdump implementation.
>
> v2 - suggestions/fixes:
>     - allocate transition page table pages below 4 GiB
>       (suggested by Jan Beulich).
>

Why?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

