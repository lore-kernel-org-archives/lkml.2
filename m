Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0HZXs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:48:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59257 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab0HZXs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:48:28 -0400
Message-ID: <4C76FD29.9040903@zytor.com>
Date: Thu, 26 Aug 2010 16:47:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 01/10] x86/iommu: Add IOMMU_INIT macros, .iommu_table
 section, and iommu_table_entry structure.
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com> <1282845485-8991-2-git-send-email-konrad.wilk@oracle.com> <20100826181913.GA5947@merkur.ravnborg.org>
In-Reply-To: <20100826181913.GA5947@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 11:19 AM, Sam Ravnborg wrote:
> 
> So we have yet another magic section in vmlinux.lds.S
> A nice comemnt that expalins what this is used for and why
> it is discardable etc. would be nice.
> 
> Lots of magic sections in same file miss this,
> but thats not an example to follwow.
> 

I added this series to tip:x86/iommu, but please do provide an
incremental patch with a comment.

Thanks,

	-hpa

