Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0LHSQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:16:33 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:58885 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858Ab0LHSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:16:31 -0500
Message-ID: <4CFFCB62.90601@euromail.se>
Date: Wed, 08 Dec 2010 19:16:02 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Chase Douglas <chase.douglas@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH] input: mt: Add hovering distance axis
References: <1291710468-2022-1-git-send-email-rydberg@euromail.se> <4CFFC45C.2040107@canonical.com> <20101208180521.GA31522@core.coreip.homeip.net>
In-Reply-To: <20101208180521.GA31522@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQOYm-0003yM-BK.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQOYm-0003yM-BK 889a5d68d33e31c7cdb6be173dce9dcb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 07:05 PM, Dmitry Torokhov wrote:

> On Wed, Dec 08, 2010 at 09:46:04AM -0800, Chase Douglas wrote:
>> On 12/07/2010 12:27 AM, Henrik Rydberg wrote:
>>> Touch devices capable of hovering, i.e., fingers detected a distance
>>> from the surface, are not supported by the current input MT
>>> protocol. This patch adds ABS_MT_DISTANCE, which may be used to
>>> indicate the distance between the contact and the surface.
>>
>> Have you given thought to calling it ABS_MT_Z instead? I have no real
>> problem with ABS_MT_DISTANCE per se, but ABS_MT_Z is more clearly
>> defined in my head. If I was new to MT development I may wonder if
>> ABS_MT_DISTANCE had anything to do with distance between points or some
>> other object.
> 
> X/Y/Z imply that we fully engaged the device and it is 3 dimensional.
> Distance says that we are approaching the device but have not directly
> engaged it yet.


Yep, and we will surely start seeing more 3D devices soon, so reserving _Z for
those is a given.

Thanks,
Henrik
