Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab2KBQz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:55:58 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:59699 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab2KBQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:55:56 -0400
Message-ID: <5093FADA.2040004@genband.com>
Date: Fri, 02 Nov 2012 10:54:50 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <50919EED.3020601@genband.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz> <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz> <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com> <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com> <20121101202701.GB20817@xo-6d-61-c0.localdomain> <5092E361.7080901@genband.com> <20121102154833.GG3300@redhat.com>
In-Reply-To: <20121102154833.GG3300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Nov 2012 16:54:51.0584 (UTC) FILETIME=[C6995C00:01CDB91A]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19334.000
X-TM-AS-Result: No--8.384300-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 09:48 AM, Vivek Goyal wrote:
> On Thu, Nov 01, 2012 at 03:02:25PM -0600, Chris Friesen wrote:

>> With secure boot enabled, then the kernel should refuse to let an
>> unsigned kexec load new images, and kexec itself should refuse to
>> load unsigned images.
>
> Yep, good in theory. Now that basically means reimplementing kexec-tools
> in kernel.

Maybe I'm missing something, but couldn't the vendors provide a signed 
kexec?  Why does extra stuff need to be pushed into the kernel?

Chris
