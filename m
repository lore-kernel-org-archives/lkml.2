Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2GBSvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:51:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2GBSu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:50:58 -0400
Message-ID: <4FF1ED8C.2080805@canonical.com>
Date: Mon, 02 Jul 2012 11:50:52 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120620 Thunderbird/14.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [PATCH] HID: magicmouse: Implement Multi-touch Protocol B (MT-B)
References: <1340913271-588-1-git-send-email-miletus@chromium.org> <20120702100741.GA1496@polaris.bitmath.org>
In-Reply-To: <20120702100741.GA1496@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 03:07 AM, Henrik Rydberg wrote:
> On Thu, Jun 28, 2012 at 03:54:31PM -0400, Yufeng Shen wrote:
>> The driver for Apple Magic Trackpad/Mouse currently uses
>> Multi-touch Protocol A (MT-A) to report touch events and uses
>> ABS_MT_TRACKING_ID to do finger tracking. The fact of the device
>> being able to track individual finger makes it possible to
>> report touch events using MT-B. This patch adds the support
>> for the driver to report MT-B and makes it configurable through
>> module parameter so that existing codes that are relying on its
>> MT-A implemtation don't get affected.
>
> Are there any such codes? Most systems, if not all, seem to use mtdev,
> which can handle both protocols. I do not think a parameter switch is
> a good idea. Switching to MT-B or leaving things as is look like the
> viable options.

Yes, let's just switch to MT-B :). Part of open source is that one can 
look at other implementations to figure out how to make your own new 
device work. We don't want to proliferate MT-A since MT-B is the way 
forward.

In fact, I would also suggest preceding this patch with one that removes 
the switch to turn touch reporting on and off. It's really unnecessary. 
I bet no one in the world turns it off :).

-- Chase
