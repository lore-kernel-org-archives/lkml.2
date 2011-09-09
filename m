Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab1IIRAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:00:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37823 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985Ab1IIRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:00:53 -0400
Message-ID: <4E6A4641.9090606@vflare.org>
Date: Fri, 09 Sep 2011 13:00:49 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Jerome Marchand <jmarchan@redhat.com>, Greg KH <greg@kroah.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] Fix sparse warnings
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org> <1315445357-14338-2-git-send-email-ngupta@vflare.org> <4E687A33.1080401@redhat.com> <4E68DBA5.6010307@vflare.org> <CAHLZz10jm4Wewxe=MAVqcq22Zoe2aTAtgsOhx7Xdq0OUz_cwgA@mail.gmail.com>
In-Reply-To: <CAHLZz10jm4Wewxe=MAVqcq22Zoe2aTAtgsOhx7Xdq0OUz_cwgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 01:32 PM, Harvey Harrison wrote:

> On Thu, Sep 8, 2011 at 8:13 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> On 09/08/2011 04:17 AM, Jerome Marchand wrote:
>>
>> Since it just fixes couple of trivial sparse warnings,
>> I though no description is necessary? Anyways, here is
>> the description if needed for patch process:
>>
>> Fixed some sparse warnings by making zram_slot_free_notify()
>> static and max_zpage_size as size_t.
>>
> 
> Please just paste the exact sparse warnings you fixed with this patch,
> then it will be more
> understandable _why_ you made the above changes.
> 



new description:

Fixes sparse warning:
zram_drv.c:666:6: warning: symbol 'zram_slot_free_notify' was not
declared. Should it be static?

Also, max_zpage_size is now size_t just to be consistent with data-type
of other variables maintaining sizes of various kinds.

Thanks,
Nitin

