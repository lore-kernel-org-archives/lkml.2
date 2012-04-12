Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2DLQtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:49:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61821 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2DLQtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120412144626.GA14868@kroah.com>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
Date: Thu, 12 Apr 2012 19:49:34 +0300
Message-ID: <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 5:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 12, 2012 at 04:32:40PM +0300, Felipe Contreras wrote:
>> On Thu, Apr 12, 2012 at 4:13 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Apr 12, 2012 at 04:03:59AM +0300, Felipe Contreras wrote:
>> >> On Thu, Apr 12, 2012 at 3:29 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> > On Wed, Apr 11, 2012 at 07:59:14PM -0400, Sergio Correia wrote:
>> >> >> Hello Greg,
>> >> >>
>> >> >>
>> >> >> On Wed, Apr 11, 2012 at 7:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> >> > This is the start of the stable review cycle for the 3.3.2 release.
>> >> >> > There are 78 patches in this series, all will be posted as a response
>> >> >> > to this one.  If anyone has any issues with these being applied, please
>> >> >> > let me know.
>> >> >> >
>> >> >> > Responses should be made by Fri Apr 13 23:10:16 UTC 2012.
>> >> >> > Anything received after that time might be too late.
>> >> >> >
>> >> >>
>> >> >> is there any chance for this one to be included in this review cycle?
>> >> >>
>> >> >> http://www.spinics.net/lists/linux-wireless/msg87999.html
>> >>
>> >> I was going to ask for exactly the same thing. My system is completely
>> >> unusable without this patch; not only does the network doesn't work,
>> >> but quite often the kernel is stuck consuming 100% of the CPU.
>> >>
>> >> > Have you read Documentation/stable_kernel_rules.txt?  Based on that, I
>> >> > don't think it can, yet, right?
>> >>
>> >> Why not? This patch makes the code go back to a previous state, it is
>> >> obviously more stable than the current state, and the code already
>> >> exists in Linus's tree (in previous releases).
>> >
>> > It does?  What is the git commit id of the patch?  Based in the email
>> > above, I assumed it had not made it to Linus's tree already.
>>
>> It's a revert of c1afdaff90538ef085b756454f12b29575411214, so so just
>> take a look at the code in c1afdaff90538ef085b756454f12b29575411214^.
>>
>> >> But hey, I guess it's OK that 3.3.x is stuck in and endless loop right
>> >> after booting, because rules are more important than fixing obvious
>> >> breakage.
>> >
>> > What rule did you think I was saying this was not acceptable for?
>>
>> The fact that the patch as not been applied/reviewed/accepted upstream.
>>
>> Personally I don't see what is the problem with reverts; we already
>> know the previous code was working. Sure, in theory it might behave
>> different due to other changes, but that doesn't seem to be the case
>> here, plus, it can't be worst than the current situation of staying in
>> an endless loop.
>
> A revert is the same as a patch.  It needs to be in Linus's tree before
> I can add it to the stable releases.

Right, because otherwise people's systems would actually work.

But hey, as I said, following rules is more important, regardless of
what the rules are, and why they are there. The rules that actually
triggered this issue in v3.3.1, as this is not in v3.3.

You could just accept that the patch should have never landed in
v3.3.1 in the first place, but it's much easier to arbitrarily keep
stacking patches without thinking too much about them.

I guess I'll better use Linus's releases for now and go to v3.3.

-- 
Felipe Contreras
