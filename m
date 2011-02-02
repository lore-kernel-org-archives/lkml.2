Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1BBObQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:31:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36085 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1BBObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:31:14 -0500
Message-ID: <4D496AAC.1010106@canonical.com>
Date: Wed, 02 Feb 2011 09:31:08 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, kraxel@redhat.com
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com>
In-Reply-To: <4D3C5F73.2050408@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2011 12:03 PM, Mark Lord wrote:
> As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
> no longer work.  And if I grab newer/patched versions of those from the latest
> Ubuntu 10.10, then those newer/patched versions do not work with kernels
> *before* 2.6.36.

I planned on taking another look at this before we release Ubuntu 11.04
at the end of April. That doesn't prevent someone else from helping out
:), but I'll make sure the utility is working again if not.

At this point it sounds like we should switch over to Gerd's new repo of
sources. Gerd, will you be making any kind of official release?

Thanks,

-- Chase
