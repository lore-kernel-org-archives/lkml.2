Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1JBALV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 20:11:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab1JBALS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 20:11:18 -0400
Message-ID: <4E87AC04.2070405@zytor.com>
Date: Sat, 01 Oct 2011 17:10:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Andy <akwatts@ymail.com>, schwab@linux-m68k.org, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus> <20111001175456.GC18690@1wt.eu> <20111001184044.GA13608@zeus> <20111001224313.GH18690@1wt.eu>
In-Reply-To: <20111001224313.GH18690@1wt.eu>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2011 03:43 PM, Willy Tarreau wrote:
> 
>   <version> <umask> <user> <group> <tag md5> <tar md5> <tar.gz md5> <status>
> 
> Since I can attest that I exclusively extracted the tarballs from the
> tar.gz and dumped their md5 at the same time, I'm pretty sure that the
> tar.gz's md5 is OK if the tar's md5 is OK. This will help speed up sig
> checks on mirrors.
> 

By the way, it's usually better to use sha256 or something else more
modern than MD5.

> All the times I got a different MD5 between the tarball and the git
> tag was because of a different user name in the tarball. It seems
> that old git versions used to use "git/git" instead of "root/root"
> now.

Yes, that change was introduced in git-1.5.0-rc1.

> This is hardcoded so it's not easy to change it, and I suspect
> that the tar format might have changed a bit, so if we want to check
> those MD5s, either we check on old mirrors that are 100% safe, or we
> have to reinstall an old version of git.

... or extract the tarball and diff the contents versus the git tree.

	-hpa
