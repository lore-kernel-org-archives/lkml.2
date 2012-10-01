Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2JASEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:04:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2JASDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:03:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: no diffstat for 'git request-pull' (was Re: [GIT PATCH] char/misc changes for 3.7-rc1)
Date: Mon, 1 Oct 2012 18:03:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, git@vger.kernel.org
References: <20121001175433.GA10092@kroah.com> <20121001175711.GB10092@kroah.com>
In-Reply-To: <20121001175711.GB10092@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210011803.48211.arnd@arndb.de>
X-Provags-ID: V02:K0:j1psAPb6rVcEOsL5AuyAeBxt3M3iQvlwwlQV9PRDIKF
 uf9dFoGkhDgA6dATdKNqE1UbeL3XT5UV9oTukgd3lxfDodXEed
 RJaf0mai9lJKZ7cdkuMvH92FoUWsZ02PDBhqW2lcJyvF11MTS/
 aMkUEXOUH6ONS5crgAot+lw4tI8n6/hIF1fLip/MtLtEGv1Z4R
 abG8VgY5bvM7xaaQqbj3CAtq90aQp9g/ei6jZQf3vVCGbmxeKY
 mYaYKH9xyE/4U2zHtHZsLJwd+q2ISyHRzHMIP4kYBtHLIuvfh9
 9FxJZbq+DRi/jF8U3KKXIFhXxLRjw5sJstPld2fdJcNtX3tIyj
 QuX2bMC2ARrEYVA6IU4I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2012, Greg KH wrote:
> Wait, what happened to the diffstat?  Does the latest version of git not
> send out the diffstat for 'git request-pull'?  It used to on older
> versions, I just updated the version on my machine that generated this
> to
>         git version 1.7.12.2.421.g261b511
> 
> Do I have to give a new option to request-pull to have the diffstat show
> up?  I'm using
>         git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-3.6
> 
> For this specific request pull.

It looks more like you just sent an empty pull request from v3.6-rc3 to 
v3.6-rc3 (fea7a08acb135).

	Arnd
