Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1HPRlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:41:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1HPRle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:41:34 -0400
Message-ID: <4E4AABC8.4090107@canonical.com>
Date: Tue, 16 Aug 2011 10:41:28 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Subject: Re: [PATCH 0/8 v3] Synaptics image sensor support
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 10:16 AM, Daniel Kurtz wrote:
> Hello,
> 
> ----
> For v3:
>   Merged Patch 5 & 6:
>      BTN_TOOL_*TAP always reports correct number of fingers.
>      During certain ambiguous number-of-finger-transitions, there may be less
>      than 2 valid MT-B slots, even if the BTN_TOOL_*TAP value indicates two or
>      more fingers are present on the pad.

I am happy with the patch series. I'm not sure if anyone will actually
use the MT slots because of all the caveats :), but this driver appears
to do the best thing I can think of with the data from the device. It
looks like it was a lot of work to figure it out, so cheers to Daniel!

At this time I see Henrik has provided two replies and Daniel has
followed up. The first reply set will cause a small amount of axis
handling changes, and the second reply about the amount of code changes
and implementation details of the tracking ids has been rebuffed. If
this is the end result, you can add my Acked-by to all the patches:

Acked-by: Chase Douglas <chase.douglas@canonical.com>

Thanks again Daniel!

-- Chase
