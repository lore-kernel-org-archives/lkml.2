Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0JMNyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:54:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0JMNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:54:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: nosy: char device is not seekable
Date: Wed, 13 Oct 2010 15:54:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de>
In-Reply-To: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010131554.43089.arnd@arndb.de>
X-Provags-ID: V02:K0:kpND3OCgaadMaOBDAznBPTiGrLr0Tn1ERrVz45E/VRR
 nPY9Qir+Rtt5WtlaqluhHw7DWo8mo8WwMz0OCY77USe1EfkzA5
 cKAMAzmXPnmghKetBtScI+cO+ZCb3QMysCHjqTQxdUc8m3EN6Z
 +hyTPAK7QqMlgS8JXgDPLPg01XE0StwkQJgKaRIIDPpZ9jc5dy
 kSZnh2j/0FY8JSoEMGmtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 October 2010, Stefan Richter wrote:
> Amend .open handler accordingly and add .llseek = no_llseek handler.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> Arnd, is your mega-patch which adds legions of .llseek handlers done and
> to be merged soon as-is, or do you regenerate it regularly?  (linux-next
> commit 9711569d "llseek: automatically add .llseek fop")

I initially planned to regenerate it, but the flux is very small, so
I have decided to keep the version I have today and only do manual updates
to remove the conflicts and add the changes for new files that are missing
the .llseek pointers.

Your patch looks good, and I'll remove my change for this file accordingly.

Thanks!

	Arnd
