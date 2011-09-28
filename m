Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1I1OLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:11:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60551 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1I1OLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:11:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 23/24] C6X: DSCR - Device State Configuration Registers
Date: Wed, 28 Sep 2011 16:11:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-24-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-24-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281611.27903.arnd@arndb.de>
X-Provags-ID: V02:K0:ScIyHBYqCnmVBFFWyXCoim6PsTRrZSPfs14WWt3yZAh
 6kCbE/wUqf5DvLhxN9AG8YrnW+47jgn+mTEGyuvk7lesY5UMGh
 X7D2bFe1bPYnSqg6o49PlRUorAD/e0gFDJl7u7FK3kfR1xA/aP
 imtLgU28H1FB7Tbtn5LG5FaOloxuvTOs1G//lfZZEN2eYs+WXb
 AG+5YlmyDATjEHcfvjwJDX7dTRLOMR9ubhFSkwvM7+JFl3eYZj
 q1ZZzumR+IUPM1kIc8Sj4FSN3+DA28wYRHTI4wVNmAI/CHouXv
 6sVZEmX2WHMRuguC6qPu+1vq/mBgtmNcmWyJf6oeuSX0aoAtkt
 9KbxXEHB8pOmBEAZsftA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> 
> All SoCs provide an area of device configuration registers called the DSCR. The
> location of specific registers as well as their use varies considerably from
> implementation to implementation. Rather than having to rely on additional
> SoC-specific DSCR code for each new supported SoC, this code generalize things
> as much as possible using device tree properties. Initialization must take
> place early on (setup_arch time) in case the event timer device needs to be
> enable via the DSCR.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
