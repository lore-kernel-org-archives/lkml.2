Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1JKPtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:49:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35909 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab1JKPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111011131428.GA13346@hallyn.com>
References: <1317943022.1095.25.camel@mop>
	<20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
	<CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
	<20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
	<CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
	<20111007152137.GE28351@carfax.org.uk>
	<20111010111813.GF17912@twin.jikos.cz>
	<20111011131428.GA13346@hallyn.com>
Date: Tue, 11 Oct 2011 08:49:13 -0700
X-Google-Sender-Auth: _d-AK9Uq69TzDqxyMSQO1fhX35U
Message-ID: <CALQRfL676ijWFeHcYCiX4Vczk4PRd2kf1aybWFNJ3a6FB1D_5A@mail.gmail.com>
Subject: Re: A Plumber???s Wish List for Linux
From: "Andrew G. Morgan" <morgan@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        KaiGai Kohei <kaigai@kaigai.gr.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The benefit of Kai Gai's patch was that it exported the actual names
of the capabilities rather than have them only stored in libcap.

It is possible to use CAP_IS_SUPPORTED(cap) (in libcap-2.21) to figure
out the maximum capability supported by the running kernel.

  https://sites.google.com/site/fullycapable/release-notes-for-libcap

Cheers

Andrew

On Tue, Oct 11, 2011 at 6:14 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> Unfortunately I'd deleted the early part of this thread before noticing
> the mention on lwn+lkml.org, but fwiw detection of the last supported
> capability has been brought up before (with patchsets floated (By KaiGai
> I'm pretty sure) which exported the list of capabilities through /sys or
> /security), and I agree it's something we need.
>
> -serge
>
