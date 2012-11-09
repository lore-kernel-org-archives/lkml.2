Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2KITnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:43:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48903 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KITnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:43:12 -0500
Message-ID: <509D5C97.2020801@oracle.com>
Date: Fri, 09 Nov 2012 14:42:15 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings (Patch v3)
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk> <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com> <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com> <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211051231070.21645@eggly.anvils> <20121106161100.216c6d79@pyramind.ukuu.org.uk> <20121106164214.GA18246@redhat.com> <20121106173845.4a50d661@pyramind.ukuu.org.uk> <509A665C.3030603@gmail.com> <20121107160232.18e83ee9@pyramind.ukuu.org.uk> <87625h9yoe.fsf@nemi.mork.no> <20121108143408.77033416@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211091133310.3733@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1211091133310.3733@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 02:34 PM, Hugh Dickins wrote:
> On Thu, 8 Nov 2012, Alan Cox wrote:
>> commit f35b3fbf24c4e4debb6a7a864b09854ccc2a22e7
>> Author: Alan Cox <alan@linux.intel.com>
>> Date:   Wed Nov 7 16:35:08 2012 +0000
>>
>>     fb: Rework locking to fix lock ordering on takeover
>>     
>>     Adjust the console layer to allow a take over call where the caller already
>>     holds the locks. Make the fb layer lock in order.
>>     
>>     This s partly a band aid, the fb layer is terminally confused about the
>>     locking rules it uses for its notifiers it seems.
>>     
>>     Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> This version works for me too - thanks.
> Hugh

I was planning to test it last night, but new code in mm/ failed horribly and
was BUG()ing all over the place, so I didn't get any significant testing
of this patch done.

Will update...


Thanks,
Sasha

