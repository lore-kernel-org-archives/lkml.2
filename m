Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2HNNih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:38:37 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:59057 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2HNNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:38:35 -0400
Message-ID: <502A541C.6090100@snapgear.com>
Date: Tue, 14 Aug 2012 23:35:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <geert@linux-m68k.org>, <ebiederm@xmission.com>,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68k: select CONFIG_GENERIC_ATOMIC64 for all m68k CPU
 types
References: <1344919533-9357-1-git-send-email-gerg@snapgear.com> <20120814051507.GA10244@localhost>
In-Reply-To: <20120814051507.GA10244@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 03:15 PM, Fengguang Wu wrote:
> On Tue, Aug 14, 2012 at 02:45:33PM +1000, gerg@snapgear.com wrote:
>> From: Greg Ungerer <gerg@uclinux.org>
>>
>> There is no specific atomic64 support code for any m68k CPUs, so we should
>> select CONFIG_GENERIC_ATOMC64 for all. Remove the existing per CPU selection
>> of this and select it for all m68k.
>>
>> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>
> Thanks for the complete solution!

I'll carry it in the m68knommu git tree, and push to Linus with my
next set of fixes.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
