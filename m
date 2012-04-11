Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab2DKX4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:56:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817Ab2DKX4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:56:02 -0400
Message-ID: <4F8619FD.1080402@zytor.com>
Date: Wed, 11 Apr 2012 16:55:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linux-foundation.org>
CC: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk> <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org> <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com> <4F81D254.9090000@zytor.com> <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com> <20120411235311.GA11310@kroah.com>
In-Reply-To: <20120411235311.GA11310@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 04:53 PM, Greg Kroah-Hartman wrote:
> 
> That all seems pretty simple.
> 
>>   - get rid of the (rather broken) idea of 'legacy' vs 'non-legacy mode'
>>     mount options in the default setup; I don't think userspace should
>>     ever be required to fiddle with such stuff
> 
> Hm, but if we get rid of them, what about tools that expect them to be
> there?  Just silently ignore them?
> 

Drop the newinstance mount option on the floor; keep recognizing the
ptmxmode mount option but change the default.

	-hpa

