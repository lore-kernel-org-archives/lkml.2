Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2GWSnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:43:55 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37938 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970Ab2GWSnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:43:53 -0400
X-Sasl-enc: cZYq6bNE68d7WKGnNIP4GJPPy3+b3SkIk6u9EjkWgcJ9 1343069032
Date: Mon, 23 Jul 2012 15:43:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Du, ChangbinX" <changbinx.du@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Do need keep mail in thread when sending a new version patch?
Message-ID: <20120723184349.GB22968@khazad-dum.debian.net>
References: <0C18FE92A7765D4EB9EE5D38D86A563A0B2DCF@SHSMSX101.ccr.corp.intel.com>
 <20120723113449.GD9103@khazad-dum.debian.net>
 <500D89D0.8080005@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D89D0.8080005@xenotime.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Randy Dunlap wrote:
> On 07/23/2012 04:34 AM, Henrique de Moraes Holschuh wrote:
> > On Mon, 23 Jul 2012, Du, ChangbinX wrote:
> >> Hi, developers!
> >> 	I have a question about sending patch: If my patch have a new version, 
> >> do I need set "--in-reply-to" option so keep them in the same thread when
> >> sending it? And in which cases should "--in-reply-to" option be set? Thanks!
> > 
> > Yes, please do it when possible.  It groups patches nicely in theaded email
> > readers, and it makes it easier for people who are interested in the subject
> > to find the new version of your patchset (and all individual patches that
> > are part of the same patchset), AND for people who are not interested to
> > skip the entire thing.
> 
> 
> Please compare to a proposed patch:
> 
>   http://marc.info/?l=linux-doc&m=133539116205348&w=2

This one (referenced by the commit changelog of the above) seems to be a
better explanation:

http://lists.infradead.org/pipermail/linux-arm-kernel/2012-April/096236.html

Anyway, I stand corrected.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
