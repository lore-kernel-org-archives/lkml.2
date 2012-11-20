Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2KTNAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:00:06 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50843 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2KTNAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:00:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121119071732.GD6135@mwanda>
References: <1353084883-8860-1-git-send-email-johanmeiring@gmail.com>
	<20121119071732.GD6135@mwanda>
Date: Tue, 20 Nov 2012 15:00:01 +0200
Message-ID: <CALqZ13v31eMRhXQ_12a9mYnF1L6gEzM8TqE9_zUUHQ_RLToAKg@mail.gmail.com>
Subject: Re: [PATCH 2/3] staging: wlags49_h2: wl_if.h: fixes several coding
 style issues
From: Johan Meiring <johanmeiring@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

100%, will do.

On 19 November 2012 09:17, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Nov 16, 2012 at 06:54:43PM +0200, Johan Meiring wrote:
>> This commit sorts out several coding style issues, including the use of C99 // comments, spaces at the start of lines, spaces before tabs, incorrect brace placement, and macros with complex values that have not been wrapped in parentheses.  The only remaining issue is the use of typedefs in two instances, but that's something that the original author might need to have a look at.
>>
>
> Could you line wrap your commit message at something like 72-73
> characters?  I think that's they rule on email, but I forget.
>
> Normally we ask that people break these kinds of changes into
> multiple patches.
> [patch 1/x] Staging: wlags49_h2: wl_if.h: use tab indents
> [patch 2/x] Staging: wlags49_h2: wl_if.h: fix comment style
> etc...
>
>> +/*
>> +#define HCF_MIN_COMM_QUALITY        0
>> +#define HCF_MAX_COMM_QUALITY        92
>> +#define HCF_MIN_SIGNAL_LEVEL        47
>> +#define HCF_MAX_SIGNAL_LEVEL        138
>> +#define HCF_MIN_NOISE_LEVEL         47
>> +#define HCF_MAX_NOISE_LEVEL         138
>> +#define HCF_0DBM_OFFSET             149
>> +*/
>
> Just delete this dead code.
>
>> +#define SIOCSIWNETNAME              (SIOCDEVPRIVATE+1)
>> +#define SIOCGIWNETNAME              (SIOCDEVPRIVATE+2)
>> +#define SIOCSIWSTANAME              (SIOCDEVPRIVATE+3)
>> +#define SIOCGIWSTANAME              (SIOCDEVPRIVATE+4)
>> +#define SIOCSIWPORTTYPE             (SIOCDEVPRIVATE+5)
>> +#define SIOCGIWPORTTYPE             (SIOCDEVPRIVATE+6)
>
> Could you put spaces around the '+' operator?
> #define SIOCSIWNETNAME          (SIOCDEVPRIVATE + 1)
>
> regards,
> dan carpenter
>
