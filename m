Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2JDVy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:54:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56362 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2JDVyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:54:54 -0400
Message-ID: <506E059B.40808@zytor.com>
Date: Thu, 04 Oct 2012 14:54:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com> <20121004164551.GA2244@phenom.dumpdata.com> <CAE9FiQWjXhat85JpXhCLApGe62mdCwb2HKhWGLjQdj2ed=6buA@mail.gmail.com> <CAE9FiQVnTqWx808F_CWaiGXT12Y4rfKPOERtSgGb=2t_4T44+A@mail.gmail.com> <506E029E.3000102@zytor.com> <CAE9FiQWPNmsw9OMrdP7Q0JnjGv66PBkAcJQhizUm0Kji-yvw8g@mail.gmail.com>
In-Reply-To: <CAE9FiQWPNmsw9OMrdP7Q0JnjGv66PBkAcJQhizUm0Kji-yvw8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 02:46 PM, Yinghai Lu wrote:
>
> or let xen map that page table by itself at first?
>

See my other post.  This is bringing up the Kernel Summit algorithm again.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

