Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2HOODp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:03:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39027 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2HOODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:03:43 -0400
Date: Wed, 15 Aug 2012 07:03:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Henningsson <david.henningsson@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 10/44] ALSA: hda - remove quirk for Dell Vostro 1015
Message-ID: <20120815140337.GA22871@kroah.com>
References: <20120813220142.113186818@linuxfoundation.org>
 <20120813220143.070291526@linuxfoundation.org>
 <5029DF77.1010301@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029DF77.1010301@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 07:17:43AM +0200, David Henningsson wrote:
> On 08/14/2012 12:02 AM, Greg Kroah-Hartman wrote:
> >From: Greg KH <gregkh@linuxfoundation.org>
> >
> >3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> As my previous email states, I still object to this patch being
> applied to 3.0 (it is for 3.2+). Repeating that text now:
> 
> This patch will not work on 3.0 because there is no model=auto
> fallback, so please remove it from 3.0-stable-queue.
> 
> In the original patch [1], the cc to stable was written as this:
> 
> Cc: stable@kernel.org (3.2+)
> 
> Is there a better way to specify what kernels it should and should
> not be applied to, as it doesn't seem to have worked in this case?
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/tiwai/sound.git;a=commit;h=e9fc83cb2e5877801a255a37ddbc5be996ea8046

No, that's my fault, sorry, I missed that marking and shouldn't have
applied it there.  I'll go remove it right now from the queue.

greg k-h
