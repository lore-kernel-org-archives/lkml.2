Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab2J0Bzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 21:55:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab2J0Bz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 21:55:28 -0400
Message-ID: <508B3EF8.4000703@vlnb.net>
Date: Fri, 26 Oct 2012 21:55:04 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <20121025140325.49cd7c79@pyramind.ukuu.org.uk> <20121025135044.GA13562@thunk.org>
In-Reply-To: <20121025135044.GA13562@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:CrU4cAZ2C+6vx+SHohCqY75FQzMk1q6OJ4Hy9zD2ABp
 7qEDi6lzGCfvXBogqpNnYkAZuJrRCK5TVPe62EJ1d4PqRzhNSc
 nvnny5fxIiP2uvADSrg9luxdqJ8vaZ47YBga8TsdtpymK70ZLm
 CSNSrO/DbgGMPiVCbiOpPPOTA/+GZTtzsNFyRshfgMNuVNcHS8
 QrDm5zFc47LzduaNckPr4foKwcDDvbzVCRRLLU2ZPPKAeTiY2X
 DLOob5BnXjVDCIb4J1sr6q0mos4t13D+fZ6Zn15iiGsdUUPRjQ
 QeoKF0rwHD0JSCorBGUM5vj7X1G4H6H5Qk1tIpDg/ZomYNqhXK
 tVpDiDOJF9hS7nLnM13k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Theodore Ts'o, on 10/25/2012 09:50 AM wrote:
> Yeah....  I don't buy that.  One, flash is still too expensive.  Two,
> the capital costs to build enough Silicon foundries to replace the
> current production volume of HDD's is way too expensive for any
> company to afford (the cloud providers are buying *huge* numbers of
> HDD's) --- and that's assuming companies wouldn't chose to use those
> foundries for products with larger margins --- such as, for example,
> CPU/GPU chips. :-) And third and finally, if you study the long-term
> trends in terms of Data Retention Time (going down), Program and Read
> Disturb (going up), and Write Endurance (going down) as a function of
> feature size and/or time, you'd be wise to treat flash as nothing more
> than short-term cache, and not as a long term stable store.
>
> If end users completely give up on flash, and store all of their
> precious family pictures on flash storage, after a couple of years,
> they are likely going to be very disappointed....
>
> Speaking personally, I wouldn't want to have anything on flash for
> more than a few months at *most* before I made sure I had another copy
> saved on spinning rust platters for long-term retention.

Here I agree with you.

Vlad
