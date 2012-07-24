Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2GXKqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:46:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49018 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2GXKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:46:22 -0400
Message-ID: <500E7CF6.2060303@ti.com>
Date: Tue, 24 Jul 2012 06:46:14 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 07/23] ARM: LPAE: use phys_addr_t for membank size
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-8-git-send-email-cyril@ti.com> <20120724100454.GD16435@mudshark.cambridge.arm.com>
In-Reply-To: <20120724100454.GD16435@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2012 6:04 AM, Will Deacon wrote:
> On Tue, Jul 24, 2012 at 02:09:09AM +0100, Cyril Chemparathy wrote:
>> This patch changes the membank structure's size field to phys_addr_t to allow
>> banks larger than 4G.
>
> This has already been fixed:
>
>    http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7465/1

Excellent.  Thanks.

>
> Will
>

-- 
Thanks
- Cyril
