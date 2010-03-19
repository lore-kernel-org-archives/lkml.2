Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0CSQ0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:26:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52778 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0CSQ0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:26:31 -0400
MIME-Version: 1.0
In-Reply-To: <fa686aa41003190915n5ec4901eya3eaf11f0b8ea63d@mail.gmail.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-3-git-send-email-gregkh@suse.de> 
	<fa686aa41003190915n5ec4901eya3eaf11f0b8ea63d@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 19 Mar 2010 10:26:10 -0600
X-Google-Sender-Auth: 2c02d7747eaa61e9
Message-ID: <fa686aa41003190926h2c5879d5k44753cc9efe17c31@mail.gmail.com>
Subject: Re: [PATCH 3/7] uartlite: Fix build on sparc.
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 10:15 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Fri, Mar 19, 2010 at 9:18 AM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
>> From: David Miller <davem@davemloft.net>
>>
>> We can get this driver enabled via MFD_TIMBERDALE which only
>> requires GPIO to be on.
>>
>> But the of_address_to_resource() function is only present on
>> powerpc and microblaze, so we have to conditionalize the
>> CONFIG_OF probing bits on that.
>>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> Hi Greg,
>
> In the end I ended up merging this one through my tree.  I picked it
> up when I needed it for my own testing and so it was in my last merge
> request for Linus.

nm.  I see your merge req, and there are no merge issues.  Sorry for the noise.

g.
