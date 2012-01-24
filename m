Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2AXNaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:30:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35494 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2AXN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 08:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120123214318.7183775c@pyramind.ukuu.org.uk>
References: <1327343540-30348-1-git-send-email-torne@google.com>
	<CAP=VYLqpUun0FtCs4VWDeLm-mAri=+UV3psRA12eVbV1So_c-Q@mail.gmail.com>
	<CAEV-rjeC1NwbUwdmEEquGf7S8uttsW5hwTjF5nTC_JXY7=OC9A@mail.gmail.com>
	<20120123214318.7183775c@pyramind.ukuu.org.uk>
Date: Tue, 24 Jan 2012 13:29:56 +0000
Message-ID: <CAEV-rjeMoC5tK48Y7JKb9NHzOhjSLE+bHt9QNqsZrB0qSmjHtg@mail.gmail.com>
Subject: Re: [PATCH] r8169: Randomise invalid MAC addresses
From: "Torne (Richard Coles)" <torne@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2012 21:43, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> So, is this just not going to be acceptable in any form? What about
>> refactoring the existing drivers that do this so that this code
>> doesn't need to be repeated in every driver, if that would help? I'd
>> really quite like to get standard linux distros to be compatible with
>> the Joggler, and this is one of the few changes that's actually needed
>> (one way or another).
>
> It ought to be about a ten line change in Red Hat/Fedora, you could also
> do it generically for most distributions as a udev rule.

OK; I'll work on that instead. Thanks for the feedback all.

-- 
Torne (Richard Coles)
torne@google.com
