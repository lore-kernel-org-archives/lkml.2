Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1JLUvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:51:49 -0400
Received: from tango.0pointer.de ([85.214.72.216]:55140 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1JLUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:51:48 -0400
Date: Wed, 12 Oct 2011 22:51:47 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: A Plumber???s Wish List for Linux
Message-ID: <20111012205147.GA3173@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
 <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
 <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
 <20111007152137.GE28351@carfax.org.uk>
 <20111010111813.GF17912@twin.jikos.cz>
 <20111011131428.GA13346@hallyn.com>
 <CALQRfL676ijWFeHcYCiX4Vczk4PRd2kf1aybWFNJ3a6FB1D_5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALQRfL676ijWFeHcYCiX4Vczk4PRd2kf1aybWFNJ3a6FB1D_5A@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11.10.11 08:49, Andrew G. Morgan (morgan@kernel.org) wrote:

> 
> The benefit of Kai Gai's patch was that it exported the actual names
> of the capabilities rather than have them only stored in libcap.
> 
> It is possible to use CAP_IS_SUPPORTED(cap) (in libcap-2.21) to figure
> out the maximum capability supported by the running kernel.
> 
>   https://sites.google.com/site/fullycapable/release-notes-for-libcap

Oh, hmm, interesting. I have now changed my code to make use of this,
but I can't say it's pretty, because I basically have to search linearly
for the highest capability supported if that's what I want to know.

So, I guess this solves the problem for now, but I'd still like to see a
proper API for this.

Anyway, thanks for the pointer,

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
