Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1CIRWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:22:55 -0500
Received: from mail.perches.com ([173.55.12.10]:4152 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab1CIRWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:22:54 -0500
Subject: Re: problem with ccflags := -Werror in Makefiles when building
 with gcc 4.6.0
From: Joe Perches <joe@perches.com>
To: Douglas Mencken <dougmencken@gmail.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Ingo Molnar <mingo@elte.hu>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <AANLkTi=3xRFt-p+HUMWwTUcUzFaxY6y9bovJiqdHTwrn@mail.gmail.com>
References: <AANLkTi=3xRFt-p+HUMWwTUcUzFaxY6y9bovJiqdHTwrn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 09:22:50 -0800
Message-ID: <1299691370.20104.127.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 17:28 +0100, Douglas Mencken wrote:
> When building with gcc 4.6.0 with the new type of warnings introduced,
> -Wunused-but-set-variable, many directories with ccflags set to
> -Werror in Makefile fail to build.

After the kbuild W=<level> gets accepted,
it might be reasonable to add another W
level to make warnings fatal and remove
all -Werror entries from the various Makefiles.

See Borislav's patch
https://lkml.org/lkml/2011/3/1/76

and Ingo's idea
https://lkml.org/lkml/2011/3/9/186


