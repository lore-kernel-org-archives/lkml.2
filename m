Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0J3Qau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:30:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27689 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab0J3Qas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:30:48 -0400
Date: Sat, 30 Oct 2010 18:20:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: Just wondering
In-Reply-To: <AANLkTi=ZTOyrNQO+-tbTBAqpHcUknxWqZ8i6cimagjjm@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1010301818320.1572@swampdragon.chaosbits.net>
References: <AANLkTi=ZTOyrNQO+-tbTBAqpHcUknxWqZ8i6cimagjjm@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Tracey Dent wrote:

> How can u get an repository at git.kernel.org for linux kernel development??

This will clone Linus' tree into a local directory named 'linux-2.6' :

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6

To update the tree you can :

$ cd linux-2.6

$ git pull

You can do the same for other trees.

Consider reading this: http://linux.yyz.us/git-howto.html


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

