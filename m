Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1I1HON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:14:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45331 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1I1HOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <1317183650.2067.10.camel@shrek.rexursive.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
Date: Wed, 28 Sep 2011 10:14:11 +0300
X-Google-Sender-Auth: Rxd6xQB-4ECvydLw_Z73ILXn0nM
Message-ID: <CAOJsxLGt717Mn50xZC5TD2s64A9vt27eAHRRFg+6nbworD4byQ@mail.gmail.com>
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 7:20 AM, Bojan Smojver <bojan@rexursive.com> wrote:
> I tested this patch on my ThinkPad T510 that has 8 GB of RAM. I booted
> Fedora 15 with Gnome 3 and started a few apps. This took about 1 GB of
> memory. Hibernation gave over 300 MB/s write speed. Thaw gave over 200
> MB/s read speed.

So how do the numbers look like without your patch?
