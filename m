Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2DBKEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:04:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57526 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2DBKD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120402025442.GA16343@gmail.com>
References: <1333300272-24563-1-git-send-email-mtottenh@gmail.com>
	<20120402025442.GA16343@gmail.com>
Date: Mon, 2 Apr 2012 11:03:58 +0100
Message-ID: <CA+h6_Vnn6C6oUS2kiV8f6=eJw6Ef0puKFQWxT-mBpwqm-cytDw@mail.gmail.com>
Subject: Re: [PATCH] Staging: bcm: IPv6Protocol: fixed mutiple coding style
 issues Fixed several coding style issues to remove most of checkpatch.pl
 errors and reduce the ammount of warnings.
From: max tottenham <mtottenh@gmail.com>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 3:54 AM, Kevin McKinney <klmckinney1@gmail.com> wrote:
> Hi Max,
>
> Thanks for taking the time to submit this patch, however, there are a few minor things that need to be resolved before it can be applied by Greg.
> Second, after I applied this patch there appears to be two errors checkpatch.pl identifies.  They are:
> ERROR: need consistent spacing around '*' (ctx:WxV)
>
> #3: FILE: staging/bcm/IPv6Protocol.c:3:
>
> +static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
>
>                                                      ^
>
> ERROR: need consistent spacing around '*' (ctx:WxV)
>
> #4: FILE: staging/bcm/IPv6Protocol.c:4:
>
> +                                       IPV6Header *pstIpv6Header);
>
>                                                   ^

After looking around apparently this is to do with checkpatch.pl not
recognizing the types and thinking the the asterisk is  a
multiplication sign  instead of a
pointer(see:http://web.archiveorange.com/archive/v/1XS1vrzkSwmm4i2t22D6)
, as to fix it you would have something like

static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE * pstClassifierRule,
                                        IPV6Header * pstIpv6Header);

which conflicts with the foo *barr notation for pointers.


> Please resubmit this patch based on these comments. Thanks a lot!
>
> -Kevin

Thanks for the comments. I'll re-factor this into a small patch set shortly.


------------------------
Max
