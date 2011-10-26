Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab1JZMgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:36:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45964 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1JZMgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <20111026121706.GC23457@suse.de>
References: <1319548607-28427-1-git-send-email-w.sang@pengutronix.de>
 <20111025153538.GA13012@google.com> <20111026121706.GC23457@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Oct 2011 14:35:47 +0200
X-Google-Sender-Auth: 6gCal_oHQzIbeV4EmiVcrj_GBdo
Message-ID: <CACxGe6st52znT6EPWDoUFE0Pvmr+CodqHCp-D7egZNy2eQL+0g@mail.gmail.com>
Subject: Re: [PATCH] lib: devres: add convenience function to remap a resource
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 2:17 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Oct 25, 2011 at 08:35:38AM -0700, Tejun Heo wrote:
>> On Tue, Oct 25, 2011 at 03:16:47PM +0200, Wolfram Sang wrote:
>> > Almost every platform_driver does the three steps get_resource,
>> > request_mem_region, ioremap. This does not only lead to a lot of code
>> > duplication, but also a huge number of similar error strings and
>> > inconsistent error codes on failure. So, introduce a helper function
>> > which simplifies remapping a resource and make it hard to do something
>> > wrong and add documentation for it.
>> >
>> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>> > Cc: Grant Likely <grant.likely@secretlab.ca>
>> > Cc: Tejun Heo <tj@kernel.org>
>> > Cc: Greg KH <gregkh@suse.de>
>>
>>  Acked-by: Tejun Heo <tj@kernel.org>
>>
>> Greg, can you please take this one?
>
> Ok, I'll queue it up after the 3.2 merge window is over, for the 3.3
> release.

You can add my a-b on this one too.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
