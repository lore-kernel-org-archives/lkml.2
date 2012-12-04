Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2LDJie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:38:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43541 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2LDJib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:38:31 -0500
Message-ID: <50BDC493.1050809@suse.cz>
Date: Tue, 04 Dec 2012 10:38:27 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/9] tty: Fix buffer work access-after-free
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 08:07 AM, Peter Hurley wrote:
> This patch series addresses the causes of flush_to_ldisc accessing
> the tty after freeing.

Hi, thanks for doing the work. The series looks good to me.

> This series also does not include Jiri's debug patch here
> https://lkml.org/lkml/2012/11/2/278 for identifying which itty cleanup
> path is used. I think it may be helpful to include this in -next.

Feel free to add your SOB and repost. Even though I have some patches in
my queue, I'm not going to send anything for the next merge window as I
will be on longish vacation and don't want to spend it by fixing tty
bugs I could introduce 8).

thanks,
-- 
js
suse labs
