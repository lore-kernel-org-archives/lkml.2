Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1DEP6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:58:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab1DEP6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:58:14 -0400
Message-ID: <4D9B3C10.9060704@suse.com>
Date: Tue, 05 Apr 2011 11:58:08 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in 2.6.36
References: <201011181650.00152.roucaries.bastien@gmail.com>	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>	<201103311704.40372.roucaries.bastien@gmail.com> <BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
In-Reply-To: <BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/05/2011 09:30 AM, Bastien ROUCARIES wrote:
> Ping ? You said on bugzilla it is related to acl but see nothing

Yeah, I think it's related to the nesting not being quite right, but I
need to look into it more. I've been unable to reproduce the problem
locally.

- -Jeff

> On Thu, Mar 31, 2011 at 5:04 PM, Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
>> Le lundi 28 mars 2011 11:14:28, Bastien ROUCARIES a écrit :
>>> On Tue, Mar 8, 2011 at 4:22 PM, Bastien ROUCARIES
>>>
>>> <roucaries.bastien@gmail.com> wrote:
>>>> On Tue, Mar 8, 2011 at 3:18 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>>> On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
>>>>>> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
>>>>>> Hi,
>>>>>>
>>>>>> I take me more than two days of testing to reporduce this bugs with
>>>>>> trace enabled. My filesystem was quite slow and this bugs seems to be
>>>>>> timing related.
>>>
>>> Any news of this bug? Could I do something to help ?
>>>
>>> bastien
>>>
>>>> Ok bastien
>>


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk2bPBAACgkQLPWxlyuTD7ILtQCcDkPc1aAWmai1nTUHFxrLZzII
iUQAn2ZLGtLFghO4oGs9R2iDiY2Mtnvz
=UrzR
-----END PGP SIGNATURE-----
