Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1BBLZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:25:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45439 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1BBLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mbycrNUN5VIbS2FE5GUCTj6RnZsdtnZ5q3PVHPtk0D5CpmE23PQYWej89hGcdpEBsy
         EByH8nr2rGd7S16MporsDcOP7ymKxkT4hmwFsVW+aEk6hpcKupbf3YPAnlLkjBcAZXtV
         z2dzlklu82HZLp2W9lVgcHijGL0E9UM8ovPxA=
Subject: Re: kernel 2.6.37 : oops in cleanup_once
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1296643972.20445.9.camel@edumazet-laptop>
References: <4D491B8D.1000107@univ-nantes.fr>
	 <1296643972.20445.9.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 12:24:47 +0100
Message-ID: <1296645887.20445.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 février 2011 à 11:52 +0100, Eric Dumazet a écrit :
> Le mercredi 02 février 2011 à 09:53 +0100, Yann Dupont a écrit :
> > Hello.
> > We recently upgraded one machine with vanilla 2.6.37, and experienced 2 
> > kernel oops since. Each oops is after ~1 week of uptime.
> > The last oops was last night but we didn't had any trace.

oops, 2.6.37 "only"

> Yes this is a known problem.
> 
> Please try commit 3408404a4c2a4eead9d73b0bbbfe3f225b65f492
> (inetpeer: Use correct AVL tree base pointer in inet_getpeer())
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3408404a4c2a4eead9d73b0bbbfe3f225b65f492
> 
> I believe David will send it to stable team shortly, if not already
> done :)

Please ignore, this patch was for linux-2.6 tree, 2.6.37 was not
affected by the problem.

So its another problem... Is there anything particular you do on this
machine ?




