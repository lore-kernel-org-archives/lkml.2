Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1HRFfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:35:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1HRFfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:35:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=i+yg70QV0ZP424SmqZFO46vWTX8Ch6SJj2rwB8+WiiInuWrXSD8byFwzwrldgGkvJ
	WtCHMvGYpZuB5ltmseqGg==
MIME-Version: 1.0
In-Reply-To: <4E4CA3A9.2010900@cn.fujitsu.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <4E4C80A0.8090708@cn.fujitsu.com>
 <87d3g347ey.fsf@emc.com.tw> <4E4CA3A9.2010900@cn.fujitsu.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 18 Aug 2011 13:34:54 +0800
X-Google-Sender-Auth: vmAVVe4NlipwBaJlpFfPeZ6FMqw
Message-ID: <CAGS+omB0Ys-vEVq64W85Jmsz=TkgvNqn_iJkxynZJr8wvqifGQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
To: gaowanlong@cn.fujitsu.com
Cc: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 1:31 PM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> On 08/18/2011 01:26 PM, JJ Ding wrote:
>>
>> Hi Wanlong Gao,
>>
>> On Thu, 18 Aug 2011 11:01:52 +0800, Wanlong Gao<gaowanlong@cn.fujitsu.com>
>>  wrote:
>>>
>>> On 08/18/2011 09:57 AM, JJ Ding wrote:
>>>>
>>>> v3 hardware's packet format is almost identical to v2 (one/three finger
>>>> touch),
>>>> except when sensing two finger touch, the hardware sends 12 bytes of
>>>> data.
>>>>
>>>> Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
>>>> ---
>>>>   Documentation/input/elantech.txt |  104 ++++++++++++++++--
>>>>   drivers/input/mouse/elantech.c   |  218
>>>> ++++++++++++++++++++++++++++++++++---
>>>>   drivers/input/mouse/elantech.h   |   11 ++
>>>>   3 files changed, 303 insertions(+), 30 deletions(-)
>>>>
>>>> +static int determine_packet_v3(struct psmouse *psmouse)
>>>
>>> elantech_check_parity_v1
>>> packet_simple_check_v2
>>> determine_packet_v3
>>>
>>> Why not consistent them?
>>
>> OK, how do these names sound to you?
>>
>> elantech_check_parity_v1
>> elantech_packet_check_v2
>> elantech_packet_check_v3
>>
>> Thanks,
>> jj
>
> Yeah, sounds perfectly.

Or just:

elantech_packet_check_v1
elantech_packet_check_v2
elantech_packet_check_v3

:)
