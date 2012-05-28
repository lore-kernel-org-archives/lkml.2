Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2E1EX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 00:23:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55735 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2E1EXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 00:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <1338172734.977.3.camel@joe2Laptop>
References: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
	<CAKPrQY8O0=PQroL6vYOCATG3WUx1ChgqW9rFqhuY2G7Q7oj3WA@mail.gmail.com>
	<1338172734.977.3.camel@joe2Laptop>
Date: Mon, 28 May 2012 09:53:24 +0530
Message-ID: <CAHdPZaMbzWBUsaTKYiApnZxhaGRqSaaaHdpPtiYSKrFLrn0rdg@mail.gmail.com>
Subject: Re: [PATCH] [staging] bcm: Fix codingstyle problems
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Kevin McKinney <klmckinney1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On Mon, May 28, 2012 at 8:08 AM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-05-27 at 22:30 -0400, Kevin McKinney wrote:
>> Hi Devendra,
>>
>> On Sun, May 27, 2012 at 4:54 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
>> > Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> > ---
>> >  drivers/staging/bcm/Debug.h |    6 +++---
>> >  1 file changed, 3 insertions(+), 3 deletions(-)
>> >
>> I understand this is a simple change, but please add a descriptive
>> change log to your patch for consistency.
>
> Hello as well.
>
> Devendra, sometimes the simpler change isn't the best change.
> Consider converting some of these macros into functions.
>
So How about converting BCM_DEBUG_PRINT, BCM_DEBUG_PRINT_BUFFER,
BCM_SHOW_DEBUG_BITMAP into a single function? and using a type to
print the corresponding values?
>
Thanks,
Devendra.
