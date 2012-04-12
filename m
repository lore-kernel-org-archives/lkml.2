Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953Ab2DLDEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:04:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58363 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2DLDEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:04:35 -0400
Date: Thu, 12 Apr 2012 04:04:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120412030425.GL6589@ZenIV.linux.org.uk>
References: <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com>
 <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com>
 <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com>
 <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120412010804.GI6589@ZenIV.linux.org.uk>
 <1ec3667a-e6f4-4032-a94b-89a6957c6252@email.android.com>
 <20120412022627.GJ6589@ZenIV.linux.org.uk>
 <fe934e2f-3482-4c23-9091-8c8debf94794@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe934e2f-3482-4c23-9091-8c8debf94794@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 07:48:44PM -0700, H. Peter Anvin wrote:
> The symlink support is at least 3 years old, probably more.

DEVPTS_MULTIPLE_INSTANCES wasn't anywhere near mandatory all that time...
Kernel upgrade procedure that starts with "build the old kernel with
that option enabled, boot it, replace /dev/ptmx with a symlink, then
never try to boot earlier kernel images.  Now you can safely upgrade
to current kernel" is the recipe for massive self-LARTs (and resulting
pitchfork crowds).
