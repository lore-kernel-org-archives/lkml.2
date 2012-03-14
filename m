Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2CNS4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:56:53 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:23046 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2CNS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:56:52 -0400
Message-ID: <4F60E9F2.2060900@tilera.com>
Date: Wed, 14 Mar 2012 14:56:50 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/tile update for 3.3
References: <4F5FCF6E.6060403@comcast.net> <CA+55aFySHdJ_LM4N7UhWektRoGK9f4+18=8xr3bMgK4gHuMqEg@mail.gmail.com>
In-Reply-To: <CA+55aFySHdJ_LM4N7UhWektRoGK9f4+18=8xr3bMgK4gHuMqEg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2012 8:06 PM, Linus Torvalds wrote:
> Ugh. When doing defconfigs, please try to use the new minconfig
> machinery to generate a somewhat sane config file, instead of one that
> contains everything.
>
> They get smaller, and actually way more relevant too.

Done and pushed up to the "stable" branch since it seemed almost like a bug
in 3.3 and thus worth fixing :-)

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

Chris Metcalf (1):
      arch/tile/configs: convert to minimal configs via "make savedefconfig"

 arch/tile/configs/tilegx_defconfig  | 1438 +----------------------------------
 arch/tile/configs/tilepro_defconfig | 1317 +--------------------------------
 2 files changed, 2 insertions(+), 2753 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

