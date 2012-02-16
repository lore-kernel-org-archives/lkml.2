Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab2BPMrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:47:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58280 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2BPMrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:47:53 -0500
Message-ID: <4F3CFAF6.1090507@gmail.com>
Date: Thu, 16 Feb 2012 21:47:50 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: seth.forshee@canonical.com
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ALPS touchpad detection
References: <4F3BABF1.8050204@gmail.com> <20120215161855.GA2495@ubuntu-macmini>
In-Reply-To: <20120215161855.GA2495@ubuntu-macmini>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for commenting.
I'll send the new one.

Seth Forshee wrote:
> On Wed, Feb 15, 2012 at 09:58:25PM +0900, Akio Idehara wrote:
>> ALPS touchpad detection fails if some buttons of ALPS are pressed.
>> The reason is that the query response byte is different from what is expected.
>> This was tested on a Toshiba Portege R500.
>
> I've reproduced the problem and confirmed that your approach fixes it.
>
> However, your patch seems to be malformed as it won't apply cleanly for
> me. For the comment you're modifying you should also keep the line
> length under 80 characters.
>
> This fix seems like a good candidate for stable as well.
>
> Seth

