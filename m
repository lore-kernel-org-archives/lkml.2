Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952Ab2DLDHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:07:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35514 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab2DLDHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:07:34 -0400
Message-ID: <4F8646DC.9020800@zytor.com>
Date: Wed, 11 Apr 2012 20:07:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org> <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com> <4F81D254.9090000@zytor.com> <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com> <20120412010804.GI6589@ZenIV.linux.org.uk> <1ec3667a-e6f4-4032-a94b-89a6957c6252@email.android.com> <20120412022627.GJ6589@ZenIV.linux.org.uk> <fe934e2f-3482-4c23-9091-8c8debf94794@email.android.com> <20120412030425.GL6589@ZenIV.linux.org.uk>
In-Reply-To: <20120412030425.GL6589@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 08:04 PM, Al Viro wrote:
> On Wed, Apr 11, 2012 at 07:48:44PM -0700, H. Peter Anvin wrote:
>> The symlink support is at least 3 years old, probably more.
> 
> DEVPTS_MULTIPLE_INSTANCES wasn't anywhere near mandatory all that time...
> Kernel upgrade procedure that starts with "build the old kernel with
> that option enabled, boot it, replace /dev/ptmx with a symlink, then
> never try to boot earlier kernel images.  Now you can safely upgrade
> to current kernel" is the recipe for massive self-LARTs (and resulting
> pitchfork crowds).

Sounds like the first thing we need to do is to remove the
CONFIG_DEVPTS_MULTIPLE_INSTANCES=n code.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

