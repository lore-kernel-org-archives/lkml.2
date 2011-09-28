Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1I1NBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:01:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58686 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <1317212552.1995.10.camel@shrek.rexursive.com>
References: <1317212552.1995.10.camel@shrek.rexursive.com>
Date: Wed, 28 Sep 2011 16:01:06 +0300
X-Google-Sender-Auth: wMQC4BSmxOOYAisXmF9AZMmHQG4
Message-ID: <CAOJsxLEL-Crbzc3-xVbEwMC1Q84+4_o6+DQpDdGO9L6eC3iRFA@mail.gmail.com>
Subject: Re: [PATCH v7]: Improve performance of LZO hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 3:22 PM, Bojan Smojver <bojan@rexursive.com> wrote:
> Use threads for LZO compression/decompression on hibernate/thaw.
> Improve buffering on hibernate/thaw.
> v7
>
> In my testing, this improved write/read speed by a factor of 2 to 3.
>
> Signed-off-by: Bojan Smojver <bojan@rexursive.com>

I tried this on my ThinkPad X220 and it makes hibernation noticeably faster.

Tested-by: Pekka Enberg <penberg@kernel.org>
