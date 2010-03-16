Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937238Ab0CPAXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:23:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab0CPAXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:23:14 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: David Miller <davem@davemloft.net>
Subject: Re: [1/3] gigaset: avoid registering CAPI driver more than once
Date: Tue, 16 Mar 2010 01:23:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.42-0.1-default; KDE/4.4.1; x86_64; ; )
Cc: tilman@imap.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       hjlipp@web.de, i4ldeveloper@listserv.isdn4linux.de
References: <1268664986.25524@pingi> <20100315.142040.58983190.davem@davemloft.net>
In-Reply-To: <20100315.142040.58983190.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003160123.06089.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX19rSJhzGR1o/7Ep2z2IoggedpgJ43lbJZFWiZN
 lRhscfMzRpiy2E1NOX+oLZe52oFPWEpNw71Sxz3CpM//KmQmET
 2Xv5YiLnQtIKj99kQw0zH4hr8nsLGmw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 15. März 2010 22:20:40 David Miller wrote:
> Karsten the way you reforward patches does not work.
> 
> And I've told you about this last time you submitted ISDN patches.
> 
> You don't add an extra "From: " line in the message body, so when the
> patch gets applied the author gets set to _you_ instead of the person
> who actually wrote the change.
>
Sorry about that.

> 
> All you're doing is ACK'ing this person's work, so simply reply to the
> patch they posted and with your "Acked-by" line.  This way patchwork
> and friends will figure out the rest when the patch gets integrated
> into the net-2.6 tree.

I tried to use my own patchwork which is feed  by the
ISDN list to learn more about it, unfortunately it does not help for such 
issues.

> 
> By reposting the patches the way you are we're losing information.
> 
> Add to this the fact that you never have the time to properly take
> care of ISDN patches, and when you do finally "get to it" you make all
> kinds of submission errors.
> 
> This is not the first time either, it happens over and over again.
> It's incredibly frustrating, especially for me.
I can understand that.
> Please seriously consider handing ISDN maintainership over to someone
> who unlike you 1) has the time and the desire and 2) knows how to
> submit patches properly.  Probably Tilman is the person who most meets
> these criteria based upon what I've seen.
> 
> Meanwhile, I'm going to apply the original patches as posted by
> Tilman so that the proper authorship gets set.

Fair enough, thanks.

Karsten
- who had really a very bad day

