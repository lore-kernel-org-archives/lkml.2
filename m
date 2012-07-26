Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2GZPsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:48:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2GZPsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120726123655.GE30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-13-git-send-email-ming.lei@canonical.com>
	<20120726123655.GE30717@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 23:48:17 +0800
Message-ID: <CACVXFVOvkdCG_cAsCQPuNQB_4BnXq8f=+RnVXH=NS5GNPvQgtg@mail.gmail.com>
Subject: Re: [RFC PATCH 12/13] driver core: firmware loader: use small timeout
 for cache device firmware
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 8:36 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Wed, Jul 25, 2012 at 01:00:12AM +0800, Ming Lei wrote:
>> Because device_cache_firmwares only cache the firmware which has been
>> loaded sucessfully at leat once, using a small loading timeout should
>
>                         least
>
>> be OK.
>
> Your commit message doesn't explain why exactly we decrease the timeout:

I have explained it. Because the firmware has been loaded successfully at least
once, so it is very probably to not timeout.

> you should probably say that this patch overrides the default 60s
> timeout because we're in pre-suspend/-hibernate mode where we have
> userspace and are able to load the firmware quickly.

No, it is not what I was saying.

Thanks,
--
Ming Lei
