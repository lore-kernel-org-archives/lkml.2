Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0J0Fuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 01:50:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60663 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0J0Fuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TuhN1qDlLGPuKOb7HYio3HjkHK1ysF8R796pNaD+KhIUS/r60syHCMuEM0ocXKOEd6
         dDkgyaaXCdqMMpAPOAChlQqdLk9IIHHTsMK3rZRqj1VrQMzdxOU36rxVRfYi93exl7HK
         +3qhUc+Ny9SKwGqvyBs9paENQ5JCimkcSpaBU=
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101027052520.GF19804@ZenIV.linux.org.uk>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
	 <1288153384-8878-5-git-send-email-david@fromorbit.com>
	 <20101027044038.GE19804@ZenIV.linux.org.uk>
	 <1288154866.2652.84.camel@edumazet-laptop>
	 <20101027052520.GF19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 07:50:23 +0200
Message-ID: <1288158623.2652.161.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 06:25 +0100, Al Viro a écrit :
> "i\xe1\xb9\x89ode_lock", i.e. 'n' turned into U+1E49, aka "latin small letter
> n with line below".  I doubt that it's MTA braindamage.
> 
> In the first patch there's 
> 
> - * invalidate_inodes    - attempt to free all inodes on a
> + * nvalidate_inodes    - attempt to free all inodes on a
> 
> and I _really_ doubt that anything in mail system is capable of something
> that elaborate.

Again, I can not see it in my copy, I checked lkml archives too :

http://lkml.org/lkml/2010/10/27/7

Mail was fine, maybe your file system is corrupted ?



