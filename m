Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1EKPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:45:49 -0400
Received: from smtp.nokia.com ([147.243.1.47]:36861 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab1EKPpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:45:47 -0400
Message-ID: <4DCA81B5.4040208@nokia.com>
Date: Wed, 11 May 2011 15:31:49 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: ext Michal Nazarewicz <mina86@mina86.com>
CC: <gregkh@suse.de>, <stern@rowland.harvard.edu>, <sshtylyov@mvista.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com> <1302015569-9668-2-git-send-email-roger.quadros@nokia.com> <op.vtg1yhef3l0zgt@mnazarewicz-glaptop> <4DCA3F90.1080208@nokia.com> <op.vvbgh8ge3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vvbgh8ge3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.36.192]
X-OriginalArrivalTime: 11 May 2011 12:29:09.0964 (UTC) FILETIME=[072C70C0:01CC0FD7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 03:19 PM, ext Michal Nazarewicz wrote:
>> On 04/05/2011 06:43 PM, ext Michal Nazarewicz wrote:
>>> On Tue, 05 Apr 2011 16:59:27 +0200, Roger Quadros wrote:
>>>> + default:
>>>> + /* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
>>>> + return -EINVAL;
>
>> On 04/05/2011 06:43 PM, ext Michal Nazarewicz wrote:
>>> Can we fall back to the old behaviour here?
>
> On Wed, 11 May 2011 09:49:36 +0200, Roger Quadros <roger.
>> What old behaviour? I didn't understand.
>
> Before we were just ignoring the type of ToC requested, right?
> So can we fail back to the ToC we served then when we hit
> an unsupported TOC? Or does it make no sense at all? I'm not
> saying it does. It probably doesn't. ;)
>

Before we were returning -EINVAL for unsupported request. We do the same now.

-- 
regards,
-roger
