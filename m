Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2HNFRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:17:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2HNFRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:17:47 -0400
Message-ID: <5029DF77.1010301@canonical.com>
Date: Tue, 14 Aug 2012 07:17:43 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 10/44] ALSA: hda - remove quirk for Dell Vostro 1015
References: <20120813220142.113186818@linuxfoundation.org> <20120813220143.070291526@linuxfoundation.org>
In-Reply-To: <20120813220143.070291526@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 12:02 AM, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>
> 3.0-stable review patch.  If anyone has any objections, please let me know.

As my previous email states, I still object to this patch being applied 
to 3.0 (it is for 3.2+). Repeating that text now:

This patch will not work on 3.0 because there is no model=auto fallback, 
so please remove it from 3.0-stable-queue.

In the original patch [1], the cc to stable was written as this:

Cc: stable@kernel.org (3.2+)

Is there a better way to specify what kernels it should and should not 
be applied to, as it doesn't seem to have worked in this case?

[1] 
http://git.kernel.org/?p=linux/kernel/git/tiwai/sound.git;a=commit;h=e9fc83cb2e5877801a255a37ddbc5be996ea8046

-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
