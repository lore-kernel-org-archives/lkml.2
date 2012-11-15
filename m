Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992509Ab2KOBQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:16:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992491Ab2KOBQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:16:29 -0500
Message-ID: <50A44267.6090103@vlnb.net>
Date: Wed, 14 Nov 2012 20:16:23 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Howard Chu <hyc@symas.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, drh@hwaci.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net> <20121113174000.6457a68b@pyramind.ukuu.org.uk>
In-Reply-To: <20121113174000.6457a68b@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:dRtV/TCqaitBFSJLawlEXFl+U8ACq5pXypcPiCZ/opY
 CRFXaC91RQqXTmsKfqNpMrN74wkiiva2cbSjYqH+35tKrCEXGj
 q2/RShoNGJGdqAhr8WOz8ItuEom3A9PmgtkG57D0wy8R3VnBOl
 epp5P7s/NiERQD0pa1VQFVUYcWv6GcWHI8UfaGcOolfJb4JQEv
 WC5K6pdbnldAiqpxSWOtbnFGH7W5H3lYAnDVlbggo7/HsDC5yr
 WGxHvlKqolhvd+PBuY2Zm9JYbSB2LUFHBh3paL/2rEKj0stvGt
 9UP3E4p9cZs0koaHfvFtMghymZi+8Tx2sNmaQ6Ow/5PQQJBbMi
 A/5qlm3pHw2u/y3WUXIo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox, on 11/13/2012 12:40 PM wrote:
>>> Barriers are pretty much universal as you need them for power off !
>>
>> I'm afraid, no storage (drives, if you like this term more) at the moment supports
>> barriers and, as far as I know the storage history, has never supported.
>
> The ATA cache flush is a write barrier, and given you have no NV cache
> visible to the controller it's the same thing.

The cache flush is cache flush. You can call it barrier, if you want to continue 
confusing yourself and others.

>> Instead, what storage does support in this area are:
>
> Yes - the devil is in the detail once you go beyond simple capabilities.

None of those details brings anything not solvable. For instance, I already 
described in this thread a simple way how requested order of commands can be 
carried through the stack and implemented that algorithm in SCST.

Vlad
