Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1HPLpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:45:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39050 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751208Ab1HPLpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:45:50 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/CAq0lhj/CRsvKcb07bL5gSvEmnJVpp9DGNrGnQD
	leVB97arPnl5zn
From: Sven Joachim <svenjoac@gmx.de>
To: =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0.2
References: <20110816015447.GA28885@kroah.com> <4E4A5087.3040102@gmail.com>
Date: Tue, 16 Aug 2011 13:45:48 +0200
In-Reply-To: <4E4A5087.3040102@gmail.com> (=?iso-8859-1?Q?=22T=F6r=F6k?=
 Edwin"'s message of "Tue, 16
	Aug 2011 14:12:07 +0300")
Message-ID: <87pqk5h95f.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-16 13:12 +0200, Török Edwin wrote:

> On 08/16/2011 04:54 AM, Greg KH wrote:
>> I'm announcing the release of the 3.0.2 kernel.
>> 
>> All users of the 3.0 kernel series must upgrade.
>> 
>> The updated 3.0.y git tree can be found at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git
>> and can be browsed at the normal kernel.org git web browser:
>>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=summary
>> 
>

> Kernel.org still shows 3.0.1, although the gitweb link points to the
> correct place repository and I can see 3.0.2 there.

There are already a gzip compressed tarball and patches in
kernel.org/pub/linux/kernel/v3.0/, but no bzip2 compressed versions.

> Is this some side-effect of switching to the linux-3.0.y.git
> repository? (the -2.6 stable repo is at 3.0.1).

I doubt that, since 3.0.1 had no such problems.  And updated
tarballs/patches for 2.6.3[23]-longterm haven't appeared at all yet,
although those are in git as well. :-(

Cheers,
       Sven
