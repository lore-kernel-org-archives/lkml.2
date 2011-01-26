Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1AZMus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:50:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1AZMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:50:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/20] hpfs: replace BKL with a global mutex
Date: Wed, 26 Jan 2011 13:50:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-11-git-send-email-arnd@arndb.de> <m2ipxc34aq.fsf@linux.intel.com>
In-Reply-To: <m2ipxc34aq.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101261350.42789.arnd@arndb.de>
X-Provags-ID: V02:K0:ZkYmJ6nn2AdK3zObRMrLbtYHMlksElhxfkd6tU2Uxol
 FIglFa4VJ/iQ9XDayStLImK5lduCD03DkJAhlx4TsOR9TwWTow
 5R56tgNTtcCITHFmLH4BLhB+yLl+5dIGOvmXEAmGlsYUUvVBIq
 vpvlBt2HLdtq6qGGu+ymQ4yKXE+zAlN4Rs1eW8qmQ+1YXUE2rX
 b9AfHQsOXJSfVtG0v6vSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 January 2011, Andi Kleen wrote:
> I don't think that's a very good idea, there's danger
> of holding it over IO and that would be really bad (as in like MINIX[1])
> 
> It would be better to do it the i810 way and check for the number of
> CPUs at module init time and refuse to run if it's > 1

I don't see much value of one evil over the other, but why not. The code
is going away anyway unless someone cleans it up further.

	Arnd
