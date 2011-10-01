Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1JAXOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 19:14:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34790 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1JAXOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 19:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
	<E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
	<20110930234711.GD14147@samba2>
	<alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
	<6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
	<20111001150730.GJ5170@giles.fritz.box>
	<6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
	<CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
Date: Sat, 1 Oct 2011 18:14:35 -0500
Message-ID: <CAH2r5mty7nqQWzv5ummBqq7tF4cknzc_f8hW9WmbOkDUKVap+Q@mail.gmail.com>
Subject: Re: CIFS kernel module bug
From: Steve French <smfrench@gmail.com>
To: Jim McDonough <jmcd@samba.org>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
        =?ISO-8859-1?Q?Lars_M=FCller?= <lmuelle@suse.de>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>, Steve French <sfrench@samba.org>,
        Jeremy Allison <jra@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 3:22 PM, Jim McDonough <jmcd@samba.org> wrote:
> On Sat, Oct 1, 2011 at 3:53 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>> Hi Lars,
>>
>> On 1 Oct 2011, at 16:07, Lars Müller wrote:
>>> On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>>>>
>>>> On 1 Oct 2011, at 01:34, J.P. King wrote:
>>>>> Anton will be asleep, so I'll attempt to answer this one.
>>>>>
>>>>>> What server code is the OES CIFS server running ? I thought Novell CIFS
>>>>>> services were all Samba based.
>>>>>
>>>>> We have been told by the people upstairs who run the server that it isn't.
>>>>
>>>> It is not Samba based.  Like Apple, Novell have written their own since Samba decided to go GPLv3…
>>>
>>> (Potential) FUD alert. ;)
>>
>> It wasn't deliberate!  It was just a guess as until recently I also though that OES just used Samba so when I two weeks ago found out that it didn't I just assumed that Novell must have written it recently and then drew the parallel to Apple and just assumed that it was an analogous case…
>
> I believe both are available on OES, samba and the CIFS server that
> has its origins in Netware.
>
>>
>>> This Novell CIFS server existed before Novell bought SUSE.  And the
>>> decission to go with it instead of Samba had nothing to do with the move
>>> of Samba from GPL v2 to v3.
>>
>> I stand corrected.  Thanks for the clarification!  From your signature I guess you would know a lot better than most.  (-:
>>
>> Best regards,
>>
>>        Anton
>>
>>> Lars
>>> --
>>> Lars Müller [ˈlaː(r)z ˈmʏlɐ]
>>> Samba Team
>>> SUSE Linux, Maxfeldstraße 5, 90409 Nürnberg, Germany
>>
>> --
>> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
>> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
>> Linux NTFS maintainer, http://www.linux-ntfs.org/

Key point is - we will fix the Linux cifs kernel client to make
reasonable workarounds for server bugs for something like this -
especially if the server is easy to download and/or test against (and
assuming it supports reasonable security - ntlmv2 and/or kerberos)


-- 
Thanks,

Steve
