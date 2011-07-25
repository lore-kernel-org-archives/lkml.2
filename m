Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1GYVI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:08:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60223 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1GYVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110725134533.GA23781@citd.de>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
	<20110725134533.GA23781@citd.de>
Date: Mon, 25 Jul 2011 22:08:24 +0100
X-Google-Sender-Auth: uaC9yXZQcr9SDFkqIEjWgWfiYFw
Message-ID: <CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 2:45 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
> On 25.07.2011 13:08, Luke Kenneth Casson Leighton wrote:
>> folks, hi,
>>
>> apart from anything, files which cannot be deleted (and cannot be
>> detected as "corrupted" by fsck.ext3) is pretty damn serious.
>
> You did try lsattr and checked that the files aren't 'immutable'?

 i didn't! :)  didn't know about (but should have guessed) ext3
attributes.  they are indeed - thank you matthias.

root@quietbaby:/mnt/horsebox/tmp3# lsattr *
----ia------------- bin3/kill
----ia------------- bin3/ps
----ia------------- c.pl
----ia------------- e.conf
----ia------------- sbin3/sysctl
----ia------------- usrbin3/uptime
----ia------------- usrbin3/tload
----ia------------- usrbin3/free
----ia------------- usrbin3/top
----ia------------- usrbin3/vmstat
----ia------------- usrbin3/watch
----ia------------- usrbin3/skill
----ia------------- usrbin3/pmap
----ia------------- usrbin3/pgrep
----ia------------- usrbin3/slabtop
----ia------------- usrbin3/pwdx
----ia------------- usrbin3/snice
----ia------------- usrbin3/pkill
----ia------------- usrbin3/w

so - looks like it's not as bad as i thought.

apologies for taking up peoples' time with this.

 l.
