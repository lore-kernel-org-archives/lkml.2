Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2HGHF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:05:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49859 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2HGHF0 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:2>);
	Tue, 7 Aug 2012 03:05:26 -0400
Message-Id: <5020DA4F02000078000931B8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 07 Aug 2012 08:05:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?B?SsOpcsO0bWVDYXJyZXRlcm8=?=" <cJ-ko@zougloub.eu>
Cc: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H.PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform
 wall clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com> <501F83F20200007800092C1C@nat28.tlf.novell.com>
 <20120806125216.GA11863@srcf.ucam.org>
 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
 <20120806091627.2ad5ed2e@zougloub.eu>
 <501FE1ED0200007800092DF0@nat28.tlf.novell.com>
 <20120806192930.77696520@zougloub.eu>
In-Reply-To: <20120806192930.77696520@zougloub.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.08.12 at 01:29, JérômeCarretero <cJ-ko@zougloub.eu> wrote:
> On Mon, 06 Aug 2012 14:25:33 +0100
> "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 06.08.12 at 15:16, JérômeCarretero <cJ-ko@zougloub.eu> wrote:
>> > If it helps:
>> > 
>> > - I can bisect the patch further down (might be a bit silly because
>> >   I don't quite understand it),
>> > - you can suggest some modifications and at least I can test them
>> 
>> What would help most would be the full kernel log up to the crash,
>> including the register and stack dumps that are presumably there.
>> Without that there's nothing I can suggest.
> 
> There is absolutely no graphical output at this point (or I'd have provided
> more info); I didn't look at the code yet, I'll see if I can do something, 
> though.

Yes, the system isn't far enough for that. You'd need a serial
(and presumably early) console set up to collect the full set of
messages.

Jan
