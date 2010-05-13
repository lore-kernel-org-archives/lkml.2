Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab0EMQWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:22:15 -0400
Received: from mail.perches.com ([173.55.12.10]:2218 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab0EMQWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:22:13 -0400
Subject: Re: [PATCH 2/2] scripts/get_maintainer.pl: add
 .get_maintainer.conf default options file
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Florian Mickler <florian@mickler.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100513155839.GE5132@cr0.redhat.com>
References: <cover.1273466698.git.joe@perches.com>
	 <61106722b46cbf707d3e2641765aae2db93b6ea7.1273466698.git.joe@perches.com>
	 <20100512063042.GB5718@cr0.nay.redhat.com>
	 <20100512112549.650b321c@schatten.dmk.lab>
	 <20100513155839.GE5132@cr0.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 09:22:11 -0700
Message-ID: <1273767731.21514.49.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:58 +0800, Américo Wang wrote:
> >hm.. the only other way to use it via git send-email would be a wrapper
> >script? 
> I still think we should avoid config files as possible as we can.

I had a request for a config capability awhile ago.

It wasn't then or is now a big deal to me.

If it's picked up by Andrew at all, I prefer the
simpler style I posted as the code is smaller and
the arguments are just the same as the command line
so all of aliases work in the .conf file as well.

I do understand the desire for a Windows style .ini
though.  If it's an .ini I think it should use:

[sections]
key=value

Maybe that only if checkpatch or some other script
uses a config as well.


