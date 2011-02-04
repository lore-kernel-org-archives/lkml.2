Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1BDWku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:40:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37495 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1BDWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Ddx/ovsNHykTIWFqGm3/uyOyu3RHA6DDN1Sv8SjDm/63dGw3wp1J24aQfLseprXL3T
         1GKtVb430IxvYWrtBWOTXQt5ZauVUmY1LLPlozj9C4Prdh+YzcxHM9nM08CXGOuxB3cK
         SDgo1+61wFusULl3H7c+nl1TvOCypy90JXXL8=
MIME-Version: 1.0
Date: Fri, 4 Feb 2011 22:40:47 +0000
Message-ID: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
From: Matt <jackdachef@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Thanks, added to the ext4 patch queue.

>I modified the commit description slightly to give credit to Jon
>Nelson, who reported the bug and really helped by devising a
>reproduceable test case.  Many thanks, Jon!!

>							- Ted

So that means that the file-corruption which existed until 2.6.37-rc6
and got triggered (for me) more easily via "dm crypt: scale to
multiple CPUs"
is fixed now ?

That should give ext4 a nice speedup for >=2.6.38 :)

Could you also please add an ?

Reported-by: Matthias Bayer <jackdachef <at> gmail <dot> com >

I mainly found it through testing with the mentioned dm-crypt scaling
patch and >=2.6.36-git*

Thanks & Regards !

Matt
