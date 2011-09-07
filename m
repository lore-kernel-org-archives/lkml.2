Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1IGBiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:38:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44253 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843Ab1IGBhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:37:55 -0400
X-Sasl-enc: zicRHSnlnxKPhMsu1IdMj3x7+2HQk/yW9WKzZLenvO1P 1315359474
Date: Tue, 6 Sep 2011 22:37:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        git@vger.kernel.org
Subject: Re: Linux 3.1-rc5
Message-ID: <20110907013750.GA25150@khazad-dum.debian.net>
References: <CA+55aFxDjVJwbpP5YT4o=qud=OcxtT3Ry4HfCtW-FvNdj+RFeQ@mail.gmail.com>
 <4E65307F.5020103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E65307F.5020103@redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Sep 2011, Mauro Carvalho Chehab wrote:
> It would be great if "git remote update" could also verify the tag
> signature (if present), as most of us just do a "git remote update".

That helps, and it really should be all that matter for a power-end-user
that just wants to build his kernel from a git tree.

However, one can still try to trick someone to base the tree he's going to
use for a future pull request on a tree with a rogue commit, in order to
try to get the rogue commit into mainline through an indirect path, for
example.

Yeah, it is very obvious, and not a real major point of concern around
LKML: we all check the diff, log or shortlog between the tree we're
offering upstream to pull from) and the current upstream tree for any
stray commits after all (if only to avoid embarassing mistakes).   And
upstream does his/her own checks before keeping the merged tree, and so
forth.

It's just that the security of the kernel source trees are not a simple
consequence of how git works: the workflow matters.  I feel that point
deserves to be stressed every once in a while, however obvious it might
be.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
