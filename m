Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0LLNha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:37:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41727 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0LLNh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:37:29 -0500
MIME-Version: 1.0
In-Reply-To: <20101211201931.00414518@endymion.delvare>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	<1292086307-19211-21-git-send-email-tj@kernel.org>
	<20101211201931.00414518@endymion.delvare>
Date: Sun, 12 Dec 2010 14:37:28 +0100
X-Google-Sender-Auth: 2jxxewYV0DFT4uj25wX_0GcB3X8
Message-ID: <AANLkTinUko5JfbYTOVujXEKqBHfdSXuqAmVcphWZyOrU@mail.gmail.com>
Subject: Re: [PATCH 20/30] macintosh/ams: don't use flush_scheduled_work()
From: Michael Hanselmann <public@hansmi.ch>
To: Jean Delvare <khali@linux-fr.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Stelian Pop <stelian@popies.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 8:19 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sat, 11 Dec 2010 17:51:37 +0100, Tejun Heo wrote:
>> flush_scheduled_work() is deprecated and scheduled to be removed.
>> Directly flush ams_info.worker on detach instead.
>
> The AMS driver is maintained by Stelian Pop and Michael Hanselmann
> according to MAINTAINERS. I am Cc'ing them both.

Change looks good to me, but can't test due to lack of hardware.

Michael
