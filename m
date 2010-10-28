Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab0J1HGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:06:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0J1HF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=shSHC6+PtcUvACiWJAkwibbMt4WyScZEfRHYLVbAUaP3vgO0wCfv81gOnr8cpWyKDp
         KXOky0PKQ8Xt3yVzyj6blBCrbIVlsYGZ+UoKz0glZPl8EI4ScH4mAYL5N1aLSQujr6ii
         njU1pWqPPArUTFaJBnMc/sW28DhRn2a9E50xc=
Date: Thu, 28 Oct 2010 07:05:50 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.35->2.6.36 regression, vanilla kernel panic, ppp or
	hrtimers crashing
Message-ID: <20101028070550.GA7647@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010251222.37191.nuclearcat@nuclearcat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-25 11:22, Denys Fedoryshchenko wrote:
> Hi
> 
> Here is what i got from netconsole
>  [  259.238755] BUG: unable to handle kernel 
>  paging request
>  at f8ba001c
>  [  259.238953] IP:
>  [<c0199ebe>] do_select+0x2cc/0x502
...
> It is not easy to do full git bisect(it is semi-embedded distro), but i can 
> try reversing particular commits, if someone can give idea which one, and can 
> try debug patches.

Hi,
Nothing concrete, but you might try reverting this one:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=commitdiff;h=15fd0cd9a2ad24a78fbee369dec8ca660979d57e

Jarek P.
