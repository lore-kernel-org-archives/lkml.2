Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab2EARgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:36:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40721 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2EARgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120430112910.14137.28935.stgit@zurg>
References: <20120430112903.14137.81692.stgit@zurg> <20120430112910.14137.28935.stgit@zurg>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 13:35:43 -0400
Message-ID: <CAHGf_=rWDMMv2dKz3paV2MnjsCNWBa2BaUTi+RnDo8DZ4zEr=g@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] proc/smaps: show amount of hwpoison pages
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 7:29 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patch adds line "HWPoinson: <size> kB" into /proc/pid/smaps if
> CONFIG_MEMORY_FAILURE=y and some HWPoison pages were found.
> This may be useful for searching applications which use a broken memory.

I dislike "maybe useful" claim. If we don't know exact motivation of a feature,
we can't maintain them especially when a bugfix can't avoid ABI change.

Please write down exact use case.
