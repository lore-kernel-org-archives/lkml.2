Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1AQBIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:08:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62972 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1AQBII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:08:08 -0500
Message-ID: <4D33965A.1090505@oracle.com>
Date: Sun, 16 Jan 2011 17:07:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>	<20110116141105.59e5b3a2@stein>	<1295214807.22813.57.camel@haakon2.linux-iscsi.org>	<20110117000659.57352da7@stein>	<AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>	<20110116231901.GF22723@ZenIV.linux.org.uk>	<AANLkTikWHkfb1-Yh_O=rYEqzgz48rwRggCp6uhr+E86J@mail.gmail.com> <20110117015220.11b43ae7@stein>
In-Reply-To: <20110117015220.11b43ae7@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/11 16:52, Stefan Richter wrote:
> On Jan 16 Linus Torvalds wrote:
>> Or do you expect a high-quality implementation of a configuration
>> script to allow the user to just say "I want ocfs2", and then figure
>> out the dependencies and solve them for you?
>>
>> I'd say that the latter case is OBVIOUSLY the quality implementation,
>> while the former one is just stupid.
> 
> As Al noted, there also needs to be a convenient way to *disable* options.
> 
> Hence, the Kconfig files should merely declare the dependencies.  Then,
> some user interfaces should deal with the this database of dependencies
> and let different people achieve different goals as easily as possible.
> 
> We already have different UIs.  But perhaps we have too much UI down in
> the Kconfig files.  I.e., perhaps Kconfig shouldn't know the difference
> between depends-on and select.  Let the different UIs present the
> dependency graph to the operator in different ways, suitable to different
> tasks.

I agree, I think that the UIs should list a kconfig symbol and its dependencies,
then let the user enable them as needed.

> /handwave off.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
