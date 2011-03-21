Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1CUKmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:42:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36051 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753008Ab1CUKmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:42:16 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX198k+J66Jh8e4Knna7yc+upTyDRv2CeEaRZikwkV4
	1uDam6AkQi2Q7f
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Andy Whitcroft <apw@canonical.com>
Subject: Re: checkpatch.pl: never finishes w/ specific file
Date: Mon, 21 Mar 2011 11:42:10 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38; KDE/4.6.1; i686; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <201103021731.01598.toralf.foerster@gmx.de> <20110316114752.GI1407@shadowen.org>
In-Reply-To: <20110316114752.GI1407@shadowen.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103211142.11317.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andy Whitcroft wrote at 12:47:52
> Could you try your file with the one below and let me know:
> 
>  
> http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl

I've a question about line 1365 :
	if ($realfile =~ m@^include/asm\/@) {

IMO either both "/" or none needs to be escaped, or ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
