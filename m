Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1IWNul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:50:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63298 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1IWNuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:50:39 -0400
Message-ID: <4E7C8EB1.5050007@lwfinger.net>
Date: Fri, 23 Sep 2011 08:50:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogMy4xLXJjNisgcnRsODE=?=
 =?UTF-8?B?OTJzZSBpc3N1ZQ==?=
References: <20110915124406.GA14374@gere.osrc.amd.com> <4E721871.7040901@lwfinger.net> <20110916180323.GA1988@gere.osrc.amd.com> <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn> <20110921185816.GA2036@gere.osrc.amd.com> <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn> <4E7AAB8B.40900@lwfinger.net> <20110922075115.GA17640@liondog.tnic> <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn> <20110923103339.GA26078@gere.osrc.amd.com>
In-Reply-To: <20110923103339.GA26078@gere.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 05:33 AM, Borislav Petkov wrote:
> On Fri, Sep 23, 2011 at 06:21:07PM +0800, 李朝明 wrote:
>> Please set ips =0 and try again..
>
> What does that mean?
>
> I can trigger the grinding-to-a-halt reliably with "ips=0" - it only
> takes a couple of hours of network traffic. Also, I don't want to try
> the driver you sent me because the version in the kernel needs fixing
> not some out-of-tree codebase.

Does the likelihood of the failure change when "ips=0" is used?

The Realtek group made several changes in the driver that Chaoming sent you that 
have not yet been incorporated in the kernel version. If you test that driver, 
we might learn if any of them are important to your problem. As neither of us 
can duplicate your results, it is not possible for us to do those tests.

I agree that we want to fix the kernel version. It is unfortunate that Realtek 
does not generate their improvements as patches to that kernel version, and 
publish them that way, but that is a fact of life. When they produce a new 
version, I have to look at the diff file between it and the previous version and 
test those differences with my devices. Thus far, there have been no changes 
that have any effect on my system, but who knows on yours. Please run the test 
as Chaoming asked you to do.

Thanks,

Larry
