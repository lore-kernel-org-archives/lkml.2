Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1KYAZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 19:25:49 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57480 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957Ab1KYAZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 19:25:46 -0500
X-Sasl-enc: TkaGOJLn3kO+KRw5kEAIxVd8RdUIjPkqvBGZhsEkZQ1M 1322180745
Date: Thu, 24 Nov 2011 22:25:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tom Gundersen <teg@jklm.no>
Cc: maciej.rutecki@gmail.com, Natanji <natanji@gmail.com>,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Regression in thinkpad-acpi events
Message-ID: <20111125002543.GC28516@khazad-dum.debian.net>
References: <4EBAC3B5.5060405@gmail.com>
 <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com>
 <201111142118.47256.maciej.rutecki@gmail.com>
 <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com>
 <20111115230305.GA23325@khazad-dum.debian.net>
 <CAG-2HqUgHAa=H6RBS2-Z3FG6OgmaWSJpdBWHn=n7Lm5O6G7ZWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqUgHAa=H6RBS2-Z3FG6OgmaWSJpdBWHn=n7Lm5O6G7ZWA@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011, Tom Gundersen wrote:
> It looks like my problem was something else. We don't do anything to
> synthesize the ACPI HKEY events (AFAIK), so I believe that KDE (which
> I am using) should be using the input events and that the HKEY stuff
> does not matter.

I have no idea if KDE can do it or not.

> As to the original report about the change in HKEY events, this is
> (probably) due to PROCFS_ACPI being disabled in the Arch kernel as of
> 3.1.

Well, maybe Arch needs to update its userspace to cope with its kernel...
but still, we will only really know whether this is the problem or not if
someone checks the input devices and the acpi events over netlink in that
Arch kernel.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
