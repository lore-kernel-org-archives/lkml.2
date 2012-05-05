Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2EEGyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:54:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60258 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752720Ab2EEGya convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:54:30 -0400
MIME-Version: 1.0
In-Reply-To: <201205042255.13508.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-4-git-send-email-ying.huang@intel.com>
	<CAErSpo59RkMo_=8E4ki+f99yDrep5ZjRY5J1CdLoMFws+n_XuQ@mail.gmail.com>
	<201205042255.13508.rjw@sisk.pl>
Date: Sat, 5 May 2012 14:54:30 +0800
Message-ID: <CAC=cRTOtkr3ABY=0yxnRrwCVa3p5+Ghx9+c2AqzxXwO6ZaHMfg@mail.gmail.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Huang Ying <ying.huang@intel.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 4:55 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 04, 2012, Bjorn Helgaas wrote:
>> On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
>> > From: Zheng Yan <zheng.z.yan@intel.com>
>> >
>> > This patch adds runtime PM support to PCIe port.  This is needed by
>> > PCIe D3cold support, where PCIe device in slot may be powered on/off
>> > by PCIe port.
>>
>> I assume this works for integrated PCIe devices as well as those that
>> are plugged into a slot and can be physically removed -- maybe the
>> text "in slot" is superfluous?
>>
>> > Because runtime suspend is broken for some chipset, a white list is
>> > used to enable runtime PM support for only chipset known to work.
>>
>> A whitelist requires perpetual maintenance.  Every time a new working
>> chipset comes out, you have to update the whitelist.  That doesn't
>> seem right.
>
> Well, we can't possibly enable the feature for all PCIe ports in existence
> either, because some of them will not work with it (almost surely).

What do you think about the idea from Bjorn to use some kind of blacklist here?

Best Regards,
Huang Ying
