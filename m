Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab0EFSAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:00:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:35320 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158Ab0EFSAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:00:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 6 May 2010 10:59:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Joe Perches <joe@perches.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: indiscriminate get_maintainer.pl usage
In-Reply-To: <1273164755.1537.40.camel@Joe-Laptop.home>
Message-ID: <alpine.DEB.2.00.1005061056300.2642@makko.or.mcafeemobile.com>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>  <4BE25AE8.1060607@s5r6.in-berlin.de>  <s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com>  <4BE26472.6040805@s5r6.in-berlin.de>  <alpine.DEB.2.00.1005060826460.10407@makko.or.mcafeemobile.com>
 <1273164755.1537.40.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Joe Perches wrote:

> There is also the --git-blame option for patches, but blame
> is also only a semi-useful tool, as it could show cleanup patches
> on individual as authors.
> 
> Another option to get_maintainers is --file-emails which looks
> inside a file for email addresses.
> 
> Right now, the default for # of git commits signed to be
> added to the CC list is 1.  It's possible to change the default.
> 
>     --git-min-signatures => number of signatures required (default: 1)
>     --git-max-maintainers => maximum maintainers to add (default: 5)
>     --git-min-percent => minimum percentage of commits required (default: 5)
> 
> Maybe some fine-tuning of the defaults could be useful.
> 
> Suggestions?

(not knowing the get_maintainers internals ...)
Maybe if you weigh each contributor by the amount (in terms of diffstat 
modulo) of changes, you can get more accurate results.
Part of the weight might be related to the time distance (relative to 
current time) since the changeset.


- Davide


