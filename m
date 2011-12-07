Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab1LGXOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:14:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab1LGXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:14:17 -0500
MIME-Version: 1.0
In-Reply-To: <loom.20111207T190350-580@post.gmane.org>
References: <20111206230107.GA22471@p183.telecom.by>
	<loom.20111207T190350-580@post.gmane.org>
Date: Thu, 8 Dec 2011 01:14:17 +0200
Message-ID: <CACVxJT-NmdAtOMJL1QCtCTztTyBHX+DgnUj7KKkDrRtJdxmUcg@mail.gmail.com>
Subject: Re: [PATCH] Add refcount type and refcount misuse debugging
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 9:22 PM, Will Drewry <wad@chromium.org> wrote:
> Alexey Dobriyan <adobriyan <at> gmail.com> writes:
>
> [snip]
>
>> Enter _refcnt_t (non-atomic version), refcnt_t (atomic version) datatypes
>> and CONFIG_DEBUG_REFCNT config option.
>
> Is kref_t not appropriate to fill this niche?

Of course, no!
kref is atomic only, kref mandates separate destructor.
bug_on's should be added there, though.
