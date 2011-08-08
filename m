Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1HHP6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab1HHP57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:57:59 -0400
Message-ID: <4E40076D.2030303@redhat.com>
Date: Mon, 08 Aug 2011 11:57:33 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Postbox Express 1.0.1 (Macintosh/20100705)
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@iki.fi>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] [media] ati_remote: add keymap for Medion X10 RF
 remote
References: <4E3DB2C2.7040104@iki.fi> <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi> <1312669093-23771-6-git-send-email-anssi.hannula@iki.fi> <20110808055754.GB7329@core.coreip.homeip.net> <4E3FF355.6090807@iki.fi>
In-Reply-To: <4E3FF355.6090807@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anssi Hannula wrote:
> On 08.08.2011 08:57, Dmitry Torokhov wrote:
>> On Sun, Aug 07, 2011 at 01:18:11AM +0300, Anssi Hannula wrote:
>>> Add keymap for the Medion X10 RF remote which uses the ati_remote
>>> driver, and default to it based on the usb id.
>> Since rc-core supports loading custom keytmaps should we ass medion
>> keymap here?
>>
>> I think we should keep the original keymap to avoid regressions, but new
>> keymaps should be offloaded to udev.
>
> Well, I simply followed the convention, as all other remotes under
> media/ have the default table in-kernel.
>
> I'm not against putting it off-kernel, but in that case the same should
> be done for all new media devices. Is that the plan?

That's the long-term plan, but not every distro has a sufficiently new 
enough v4l-utils and ir-keytable with udev rules to load keymaps, so 
we've been adding default remotes in-kernel and userspace (effectively 
meaning duplicated keymap loads if the user does have ir-keytable with 
udev rules, but meh). I'd say add it for now, and when we get to the 
point of v4l-utils ubiquity, we can drop this along with all the other 
in-kernel rc keymaps.

-- 
Jarod Wilson
jarod@redhat.com


