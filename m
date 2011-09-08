Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1IHXR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:17:26 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63814 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1IHXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <4E68DBA5.6010307@vflare.org>
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
	<1315445357-14338-2-git-send-email-ngupta@vflare.org>
	<4E687A33.1080401@redhat.com>
	<4E68DBA5.6010307@vflare.org>
Date: Thu, 8 Sep 2011 10:32:26 -0700
Message-ID: <CAHLZz10jm4Wewxe=MAVqcq22Zoe2aTAtgsOhx7Xdq0OUz_cwgA@mail.gmail.com>
Subject: Re: [PATCH 1/5] Fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Greg KH <greg@kroah.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 8:13 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> On 09/08/2011 04:17 AM, Jerome Marchand wrote:
>
> Since it just fixes couple of trivial sparse warnings,
> I though no description is necessary? Anyways, here is
> the description if needed for patch process:
>
> Fixed some sparse warnings by making zram_slot_free_notify()
> static and max_zpage_size as size_t.
>

Please just paste the exact sparse warnings you fixed with this patch,
then it will be more
understandable _why_ you made the above changes.

Harvey
