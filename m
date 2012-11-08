Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2KHAP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:15:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2KHAP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:15:56 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Solda <dso@cypress.com>
Cc: Troy Abercrombia <ta@cypress.com>, Kamal Mostafa <kamal@canonical.com>,
        Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozancag@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        customercare <customercare@cypress.com>,
        "mario_limonciello@dell.com" <mario_limonciello@dell.com>
Subject: Re: Why Cypress does not upstream its trackpad driver?
Date: Wed, 07 Nov 2012 16:15:49 -0800
Message-ID: <2208882.BvOrfBvj6F@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc3+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <EE629F2C-DD83-403C-AD73-E9ED966EEA91@cypress.com>
References: <CAFub=KTf2dWxM9=saG2JaNJpEioJM8rM3UBG9BkyxRN-+j0psQ@mail.gmail.com> <C825ADB6BE8AC2468577BFFCE7DF5B8A1F080FA111@VMBX133.ihostexchange.net> <EE629F2C-DD83-403C-AD73-E9ED966EEA91@cypress.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wednesday, November 07, 2012 06:30:11 PM David Solda wrote:
> Kamal,
> 
> My name is Dave Solda and I would be happy to answer any other questions
> that you have. Troy's response is correct however as in order to support
> the default Linux mouse class, our firmware would also have to be modified
> to do so, which cannot be done in system. Our packet protocol maxes out at
> an 8 byte packet, which requires a change to the Linux standard in this
> case.

I am unable to parse this... I do not believe anyone asks you to change
your firmware and if your protocol needs 8 bytes to transmit device state -
that's fine.

> Our goal in working with canonical was to provide something on Linux that
> would support multi-touch and not only have default single finger movement
> supported.
 
> If I am mistaken and he Linux kernel would accept this, then we can proceed
> to upstream, however all indications we have is that this patch would be
> rejected.  If you (or others on from the locus alias) have any inputs, I
> would be happy to receive them.

This really depends on whether the changes to the psmouse framework make
sense or not. Please start submitting patches for review/discussion and
we can go from there.

Thanks.

-- 
Dmitry
