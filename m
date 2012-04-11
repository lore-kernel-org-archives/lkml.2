Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2DKJLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:11:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52367 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2DKJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:11:12 -0400
Message-ID: <4F854AAC.3030409@gmail.com>
Date: Wed, 11 Apr 2012 11:11:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: i915: NULL pointer dereference in pagevec_move_tail
References: <4F840300.3090101@suse.cz>
In-Reply-To: <4F840300.3090101@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 11:53 AM, Jiri Slaby wrote:
> in today's -next I see:
> BUG: unable to handle kernel NULL pointer dereference at           (null)

Forget about that, it was some fuzz. I cannot reproduce with today's -next.

thanks,
-- 
js


