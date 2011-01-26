Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1AZET6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:19:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60446 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1AZET5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:19:57 -0500
MIME-Version: 1.0
In-Reply-To: <20110126031734.GA1636@suse.de>
References: <20110126015414.31133.56437.stgit@localhost6.localdomain6> <20110126031734.GA1636@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jan 2011 21:19:36 -0700
X-Google-Sender-Auth: 02jRE8rTbW7LS5-2mfV8BIx6V88
Message-ID: <AANLkTinf6+FN90tyLd6f1guvppt5s5PQL3ZkcecCCX+E@mail.gmail.com>
Subject: Re: [PATCH] driver-core: remove conditionals around devicetree pointers
To: Greg KH <gregkh@suse.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 8:17 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Jan 25, 2011 at 07:02:02PM -0700, Grant Likely wrote:
>> Having conditional around the of_match_table and the of_node pointers
>> turns out to make driver code use ugly #ifdef blocks.  Drop the
>> conditionals and remove the #ifdef blocks from the affected drivers.
>>
>> Also tidy up minor whitespace issues within the same hunks.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> I've held off doing this since I didn't want to needlessly increase
>> the size of struct device and struct device_driver for users who don't
>> use CONFIG_OF.  However, its quibbling about a tiny amount of memory,
>> and #ifdef'ing it out this way is ugly for driver code.
>>
>> Alternately, if I should be concerned about the extra memory, I could
>> define some macros/inlines similar to how CONFIG_NUMA is handled.
>
> No objection from me, I was wondering when you would get around to doing
> this :)
>
> If you want me to take this in my tree, I'd be glad to, otherwise feel
> free to send it through yours, and add a:
>        Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to it.

Thanks.  I'll take it via my tree.

g.

>
> Nice job,
>
> greg k-h
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
