Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab2CNQC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:02:27 -0400
Received: from mail-fa0-f46.google.com ([209.85.161.46]:59621 "EHLO
	mail-fa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab2CNQC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:02:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAC9WiBgxrNBqRMx_2-FGcY1mGroi=mRxGV31idunkhUTwCNskg@mail.gmail.com>
References: <CAC9WiBiZ9oOaDaYjow-ZryZ8i=7uLixTAfm48YKVpbwQfLfayQ@mail.gmail.com>
	<20120314154339.GB25000@redhat.com>
	<CAC9WiBgxrNBqRMx_2-FGcY1mGroi=mRxGV31idunkhUTwCNskg@mail.gmail.com>
Date: Wed, 14 Mar 2012 12:02:24 -0400
Message-ID: <CA+5PVA6wrcxFUEoRFBLj9+2u0MeAAi5TDXDVB-M4QV0a65K4Hg@mail.gmail.com>
Subject: Re: Getting oops with 3.2.10 when removing a SD card
From: Josh Boyer <jwboyer@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:50 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> On Wed, Mar 14, 2012 at 4:43 PM, Dave Jones <davej@redhat.com> wrote:
>> On Wed, Mar 14, 2012 at 04:38:04PM +0100, Francis Moreau wrote:
>>  > Hi,
>>  >
>>  > I'm getting this oops (pretty often) after writing to a SD card and
>>  > removing the card.
>>  >
>>  > Could anyone have a look please ?
>>
>> Should be fixed by this patch that has been around for a while now.
>>
>
> Why isn't it mainlined then ?

Because it's been sitting in the subsystem maintainer's tree for a while.
He sent a pull request to Linus earlier today to get it included in 3.3.

josh
