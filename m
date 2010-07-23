Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab0GWCWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:22:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47466 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0GWCWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=w1pGP7W0VPDaXSucN/gKG5qEPsNDNK6K+Tfey5maEyEsB3y0ZhxlFhv+ocD6AFc6ao
         d+576WnI3rGhoezZ8J0SwQuv/BkI0nCCHX7Tepp8UnrsG+ZTJVIBaTHARWuDgVXFK1bt
         8se/M7kgSjmZIwY/CHhZu9uGVURbaempxKudY=
MIME-Version: 1.0
In-Reply-To: <20100722150145.GE14882@thunk.org>
References: <AANLkTilaycSLL2dDnXDVs1gCiD0B8K78i2rBdWJGZrRD@mail.gmail.com> 
	<20100722150145.GE14882@thunk.org>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Fri, 23 Jul 2010 10:22:08 +0800
Message-ID: <AANLkTinISdrdpYfgVzTAhgQmdJculdOJ5qNPdvNCBPjE@mail.gmail.com>
Subject: Re: openvz: Oops in ext4 when VPS starts
To: "Ted Ts'o" <tytso@mit.edu>, Drunkard Zhang <gongfan193@gmail.com>,
        linux-kernel@vger.kernel.org, devel@openvz.org,
        Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/22 Ted Ts'o <tytso@mit.edu>:
> On Thu, Jul 22, 2010 at 05:39:16PM +0800, Drunkard Zhang wrote:
>> I run into a oops when mirgate /vz directory to ext4 lvm under gentoo + openvz.
>
> What were you doing precisely at the time of the oops?  The oops logs
> indicates it was a cp, but a cp of what?  And is this somethign you
> can easily reproduce?
>
I did: "/etc/init.d/vz start" with vpsid 101 and 109, which from:
http://bb.xnull.de/projects/gentoo/amd64/stage4-amd64-current.tar.bz2
following the guide from:
http://www.gentoo.org/proj/en/vps/openvz-howto.xml

Didn't change the content of stage4-amd64-current.tar.bz2 yet.
It looks like when "/etc/init.d/vz start", it will cp all files from
/vz/private/101/ to /vz/root/root/101/

The oops allways reproduced yesterday between reboot and kernel
remake, but this morning when I trying to finger out the oops point
using strace, I can't get the oops anymore. Sorry for interrupt,:-(

Maybe distcc caused problem? I used to make kernel... Sorry again.
