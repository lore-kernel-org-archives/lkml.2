Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2KZGO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:14:57 -0500
Received: from 173-254-64-10.unifiedlayer.com ([173.254.64.10]:53700 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753874Ab2KZGO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:14:56 -0500
Message-ID: <50B308D8.2060501@tao.ma>
Date: Mon, 26 Nov 2012 14:14:48 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, torvalds@linux-foundation.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126002814.GM32450@dastard> <20121126025520.GC22858@thunk.org>
In-Reply-To: <20121126025520.GC22858@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
On 11/26/2012 10:55 AM, Theodore Ts'o wrote:
> On Mon, Nov 26, 2012 at 11:28:14AM +1100, Dave Chinner wrote:
>> fs: revert commit bbdd6808 to fallocate UAPI
>>
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Commit bbdd6808 ("fs: reserve fallocate flag codepoint") changes the
>> fallocate(2) syscall interface. The flag that is reserved by this
>> commit is for functionality that has previously been NAKed on the
>> -fsdevel mailing list, and so exists out-of-tree.
> 
> Hi Linus,
> 
> It doesn't change the interface or break anything; it just reserves a
> bit so that out-of-tree patches don't collide with future allocations.
> There are significant usages of this bit within Google and Tao Bao.
> It is true that there has been significant pushback about adding this
> functionality on linux-fsdevel; I find it personally frustrating that
> in effect, if enough people scream, they can veto an optional feature
> that might only be implemented by a single file system.
Sorry, but we(Tao Bao) should say it explicitly that it is currently
used in our product system. So we are with Ted that there should be no
side effect for reserving just a bit to avoid future conflict?

Thanks
Tao
