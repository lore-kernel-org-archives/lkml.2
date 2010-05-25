Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab0EYJwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:52:19 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:62282 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0EYJwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=dSbXjiYTGePayuzdjNNBFu/WTccCIi3uz6L8veA7pqIEecpToPqG21lh/RyXETTaUm
         ks8tiWJEj8btjLvAScmfex2+TSIB+lnCLvgXVjNUs+2ijO2xBjTuXtD6gbYarSKtqp0y
         cWJIEhcUwXhalEIZVG3ly+1GB4cYV97N+QMfk=
MIME-Version: 1.0
In-Reply-To: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
Date: Tue, 25 May 2010 11:52:12 +0200
Message-ID: <AANLkTik_QdZN_nFoOVD3-1JTGN5oxRySCdV5_eDqvQve@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, erik_list@caneris.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

unfortunately, I lack the thread [1] in which John and Erik so I am
replying in my initial thread.

Unfortunately, our own patch is still in its initial state even though
we tried to clean it up to the Kernel's standard.

As you can see in [1], there is a real problem with multilink ppp. Thus,
I wanted to take the opportunity to ask for someone who is more familiar
with both C and the Linux Kernel than we are to have a go at getting
this code cleaned up and into mainline.


Any and all feedback appreciated,
Richard

[1] http://marc.info/?l=linux-ppp&m=127429724125841&w=2
