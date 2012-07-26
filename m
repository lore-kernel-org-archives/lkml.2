Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2GZCef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:34:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2GZCed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <500FA653.7090808@codeaurora.org>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-8-git-send-email-ming.lei@canonical.com>
	<500FA653.7090808@codeaurora.org>
Date: Thu, 26 Jul 2012 10:34:31 +0800
Message-ID: <CACVXFVNXhSfzVf=oZT_mYG0Rmc3vX=vF32Wm06ji0ztyVVs9oA@mail.gmail.com>
Subject: Re: [RFC PATCH 07/13] driver core: firmware loader: introduce
 cache_firmware and uncache_firmware
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 3:54 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 7/24/2012 10:00 AM, Ming Lei wrote:
>>
>> +
>> +int cache_firmware(const char *name)
>> +{
>> +     return -ENOENT;
>> +}
>> +
>> +int uncache_firmware(const char *name)
>> +{
>> +     return -EINVAL;
>> +}
>
> These stubs need to be static inline to avoid compiler warnings.

Good catch, will fix it in v1.

Thanks,
--
Ming Lei
