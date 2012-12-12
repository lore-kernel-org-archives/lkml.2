Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2LLUXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:23:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62736 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2LLUXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:23:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121212210434.5cadf42c@neptune.home>
References: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
	<20121212014109.38e18eeb@neptune.home>
	<CAGDELX6rtztDzQobfaUNB2iZSyxGL9vzu5mM4sG7bDip=SaBag@mail.gmail.com>
	<20121212020348.0afa77e2@neptune.home>
	<CAGDELX6L89ux2TXJLnm5aC2zNdSqQDZws+c5-OA0Xbtkt7Nw5g@mail.gmail.com>
	<CAGDELX6CPevOq8EowLu1GUwiS6Yw4vjOz3S2AOewFBbt0pC_dw@mail.gmail.com>
	<20121212210434.5cadf42c@neptune.home>
Date: Wed, 12 Dec 2012 21:23:49 +0100
Message-ID: <CAGDELX4URjjVOXB-OgXkaeDsSVKS_=eTYTyX=sXjH-fnwdn_Hw@mail.gmail.com>
Subject: Re: "attempt to access beyond end of device" on DVD
From: Jacek Poplawski <jacekpoplawski@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12, Bruno Prémont <bonbons@linux-vserver.org> wrote:
> On Wed, 12 December 2012 Jacek Poplawski <jacekpoplawski@gmail.com> wrote:
>> OK, I was wrong previously.
>>
>> I don't need to reload sr_mod, I only need to remount DVD.
>>
>> The reason I was wrong is I was suspecting that DVD remounts itself
>> after eject, but looks like it doesn't. Also it means that the problem
>> is different than 3 years ago, because I am sure I was remounting DVD
>> by hand and now I use some automount feature of Arch Linux / GNOME3.
>
> What kind of filesystem do you have on your CD/DVDs?

I backup files with k3b with default settings, so it is iso9660.

However I don't fully understand how this automount works, I am afraid
this problem it may be related to this mechanism. When I insert first
DVD it's mounted and when I remove DVD and put another one it's still
mounted as before, so maybe driver is confused and still thinks the
size of the DVD is like the first one.
