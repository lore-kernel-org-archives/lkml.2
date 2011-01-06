Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab1AFIbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:31:46 -0500
Received: from borg.asidev.net ([95.141.38.199]:51827 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1AFIbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:31:45 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 03:31:45 EST
Message-ID: <4D257DEE.40009@evidence.eu.com>
Date: Thu, 06 Jan 2011 09:31:42 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: On Linux numbering scheme
References: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com> <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>   As time passes by, the Linux numbering scheme makes even less sense.
>   Some time ago there was a discussion on LKML about a new numbering
>   scheme but it didn't come to any positive conclusion and then the
>   subject was forgotten entirely. Not meaning to raise a clamour here
>   (and I suppose I represent a large group of Linux users here). I'm
>   willing to suggest a numbering scheme which I hope will answer all
>   known complaints and criticism.

This seems to be a periodically recurrent topic on the list.
	
If I've correctly understood all points of view, there are currently two
groups of developers:

1. Those who want to maintain the current numbering scheme, because they
feel comfortable with it, and because they can easily understand the
number of releases between one release and another.

2. Those who prefer having a scheme somehow related to the date, so they
can easily understand when a certain kernel has been released (i.e. how
"old" it is).

Does really exist a numbering scheme that can satisfy both groups of
people ? Probably not.

My only idea would be to maintain the usual numbering scheme, and just
replace the second number (6) with the year of release.

For example:

	2.6.36 would be 2.10.36

	2.6.37 would be 2.11.37

	2.6.38 would be 2.11.38

	and so on...

This way, you put some information about the year of release without
loosing all the benefits of the current scheme.

But this means having two independent incremental numbers, which maybe
is a too insane scheme.

Regards,

	Claudio
