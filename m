Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab2CMTjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:39:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606Ab2CMTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:39:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Renesas SoC updates for v3.4, take 2
Date: Tue, 13 Mar 2012 19:39:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Paul Mundt <lethal@linux-sh.org>
References: <201203092155.04731.rjw@sisk.pl> <201203131026.08495.arnd@arndb.de> <201203132036.22991.rjw@sisk.pl>
In-Reply-To: <201203132036.22991.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203131939.36186.arnd@arndb.de>
X-Provags-ID: V02:K0:kA5Z34uUZRvIKdCHVez8AQo13td5/W3q3QJXMGHxSFQ
 GTIzzV7zRMoUqw1gwFJEP9lesF23ANZDJYmrHtCMlfWD+gnwic
 HcT8bvkjQPsDEJUqQR+jsTIoDJx4pC0RnexdTOlSrh3v3GjAD+
 4mybos7tZMJu++6NAX6+CwQalaVjKjRQhDo29egXwFwbF1ouBL
 Tfvdv2MW8qM3SnzrxnxH546kkXUs4ra+xJ5jsagHmV0aOS3aed
 IELQ/5PjerUDDGRI2XibZiSl8M/ixb5lOqcvgKx7mDZpsaTe8D
 gEUB/mstBKqSDQ39syLMwe7TDfER0IuGL4EaAiPip2qAmD0sbM
 katVoFm1j5V+wZlACAHM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2012, Rafael J. Wysocki wrote:
> > Note that the __io() issue has turned out to be more urgent than I first
> > thought when we discussed it, so it would be good to apply the patch below
> > on top of your series.
> 
> Do you want me to apply it now or will you do that in your tree?

Doesn't matter to me, as long as one of you applies it ;-)

	Arnd
