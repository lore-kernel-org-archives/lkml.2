Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab0HNWLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:11:38 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:44002 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0HNWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:11:37 -0400
Message-ID: <4C671497.4050701@mandriva.org>
Date: Sun, 15 Aug 2010 01:11:35 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Gabor Z. Papp" <gzp@papp.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.52 stable review
References: <20100813214704.GA18960@kroah.com> <x6r5i1o3dc@gzp> <20100814210135.GA7745@suse.de>
In-Reply-To: <20100814210135.GA7745@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH skrev 15.8.2010 00:01:
> On Sat, Aug 14, 2010 at 01:11:43PM +0200, Gabor Z. Papp wrote:
>> * Greg KH<gregkh@suse.de>:
>>
>> | If I could get some people to please test this -rc release?
>>
>> BTW seems like 2.6.27 no more combatible with GNU Make 3.82:
>>
>> $ make oldconfig
>> Makefile:443: *** mixed implicit and normal rules.  Stop.
>>
>> Same with line 1609.
>
> Nothing has changed with the main Makefile with the exception of
> changing the version number for a very long time.
>
> Did something else change on your system?
>
> odd,
>

2.6.27 needs this wich went in after 2.6.28-rc8:

kbuild: fix make incompatibility
author	Sam Ravnborg <sam@ravnborg.org>	
	Sat, 13 Dec 2008 22:00:45 +0000 (23:00 +0100)
committer	Sam Ravnborg <sam@ravnborg.org>	
	Sat, 13 Dec 2008 22:00:45 +0000 (23:00 +0100)
commit	31110ebbec8688c6e9597b641101afc94e1c762a
tree	208aaad7e40cbb86bc125760664911da8cd4eebb	tree | snapshot
parent	abf681ce5b6f83f0b8883e0f2c12d197a38543dd	commit | diff
kbuild: fix make incompatibility

"Paul Smith" <psmith@gnu.org> reported that we would fail
to build with a new check that may be enabled in an
upcoming version of make.

The error was:

       Makefile:442: *** mixed implicit and normal rules.  Stop.


And I assume the powerpc make-3.82 fix 
(e32e78c5ee8aadef020fbaecbe6fb741ed9029fd)
needs to be added to 2.6.27 too...

--
Thomas
