Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1HLQOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:14:42 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39200 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1HLQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:14:41 -0400
Message-ID: <20110812181439.679457iwczsk6x8o@ssl.lux01.de>
Date: Fri, 12 Aug 2011 18:14:39 +0200
From: markus@trippelsdorf.de
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git.kernel.org has issues accessing torvalds/linux.git
References: <CACTFLANCxbACB5yNZvHOmuZDfpuDN1TkABV2BgmvJwQ5RBVKYw@mail.gmail.com>
In-Reply-To: <CACTFLANCxbACB5yNZvHOmuZDfpuDN1TkABV2BgmvJwQ5RBVKYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 12 Aug 2011, Daniel Mack <zonque@gmail.com> wrote:
> Does anyone else see this?
>
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> Cloning into linux...
> fatal: The remote end hung up unexpectedly
> $ git clone  
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> Cloning into linux-2.6...
> fatal: The remote end hung up unexpectedly
>
> However, other repositories seem to work fine:

Yes. This is the second time in the last few days
that this has happened.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit
  404 - Unknown commit object

-- 
Markus

