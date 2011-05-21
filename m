Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1EUOky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:40:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35063 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1EUOkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IUV3qZiBt5KSgU0Q1E4DWQIfNRHfeJOoueWzbzbBqpvHTy2XrQ/9klGIRXexMbFdFC
         L9abqGk2WbkO0c4ycQldkT2xLtOEJVjyM2KJmLXUIuTM3mNhXPefC50WcsAhNDQGZ1h9
         chmS8G0EUerLoLKmg8Vit3vpOOXqQoGPn3EjY=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: roucaries bastien <roucaries.bastien+linux@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Six month old regression with dataloss, confirmed but no clue
Date: Sat, 21 May 2011 16:40:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <BANLkTin1uWZUS21Ey6chY0E=Nu50MJFCWA@mail.gmail.com> <BANLkTinXnjvG4p9WqoYc7ttyXZ7gQSBhsQ@mail.gmail.com>
In-Reply-To: <BANLkTinXnjvG4p9WqoYc7ttyXZ7gQSBhsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105211640.45890.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 18 mai 2011 14:24:26, roucaries bastien a écrit :
> Hi,
> 
> I resend an email about https://bugzilla.kernel.org/show_bug.cgi?id=29162
> 
> This bug was confirmed by Frederic Weisbecker but we have no clue how
> to reproduce quickly. Only run kamil and git for some time and get
> stuck.
> 
> We are even not sure if it is a reiserfs bug and a core fs bug. It
> seems related to acl is the only clue.
> 
> Any help is welcome.
> 
> Thansk to frederick for trying to reproduce so far
> 
> Bastien
> 
> Ps: sorry for resending typo on lkml
I have just posted a new trace with 2.6.37
