Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab2KEPjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:39:17 -0500
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:40530 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab2KEPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:39:11 -0500
Message-ID: <5097DD2E.9040909@genband.com>
Date: Mon, 05 Nov 2012 09:37:18 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <50919EED.3020601@genband.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz> <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz> <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com> <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com> <20121101202701.GB20817@xo-6d-61-c0.localdomain> <5092E361.7080901@genband.com> <20121102154833.GG3300@redhat.com> <alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz> <87390ok0zy.fsf@xmission.com> <alpine.LNX.2.00.1211051535060.24253@pobox.suse.cz> <alpine.LNX.2.00.1211051628380.24253@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1211051628380.24253@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2012 15:37:19.0764 (UTC) FILETIME=[71233540:01CDBB6B]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19342.000
X-TM-AS-Result: No--3.658800-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 09:31 AM, Jiri Kosina wrote:

> I had a naive idea of just putting in-kernel verification of a complete
> ELF binary passed to kernel by userspace, and if the signature matches,
> jumping to it.
> Would work for elf-x86_64 nicely I guess, but we'd lose a lot of other
> functionality currently being provided by kexec-tools.
>
> Bah. This is a real pandora's box.

Would it be so bad to statically link kexec?

Chris
