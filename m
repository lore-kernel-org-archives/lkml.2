Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0KSQtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:49:21 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64331 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0KSQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:49:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iJSFdewVtReXTBjKLfPosne27S2W6Zjz4414KRfzT73v6UVOP/nWcE91nrKbn/q6qz
         CKoBt4FBsE0BAxjCzuHlBVPKV2ngM4k/ENiFJQrXm4wV5Bl9jeA77CegxsvTPMer8+SE
         XUNhMtyX7yt46bmwB1IvxxwKMZiQ9gW3g/Kuw=
From: Jordi Pujol <jordipujolp@gmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Galbraith patch
Date: Fri, 19 Nov 2010 17:49:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-0.jpp.11-lnet-amd64; KDE/4.4.5; x86_64; ; )
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
References: <201011191509.49586.jordipujolp@gmail.com> <201011191005.12189.gene.heskett@gmail.com>
In-Reply-To: <201011191005.12189.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191749.14781.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Divendres 19 Novembre 2010 16:05:12, Gene Heskett va escriure:
> Thanks Jordi, but my last attempted build, using only the last 2 patches 
> that Mike posted on a fresh unpack of 2.6.36, couldn't get past stage 2 of 
> the modules build, it kept squawking about all the IR control stuff that
> is  not even configured to be built.
> 
> I wonder how long it will take to get work this into mainline?
> 
> Along the same line, how does this compare to CK's bfs patch?

the autogroup-sched patch works well, right now writing this message from a 
computer that runs that kernel.

this patch is much simpler than CK2, so I suppose that the implementation 
should be more easy,
I am trying both and observe, from my user's point of view, that they give a 
similar result.

Gene, if that may help to do your own kernel implementation, the Debian kernel 
sources I've used are available at:
http://livenet.selfip.com/ftp/debian/linux-2.6/

2.6.36 + CK2, in the subdirectory
   linux-2.6.36-0.jpp.10-lnet/
2.6.36 + autogroup_sched, in the subdirectory
   linux-2.6.36-0.jpp.11-lnet/

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com
