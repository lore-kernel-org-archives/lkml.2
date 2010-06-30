Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab0F3W6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:58:18 -0400
Received: from xenotime.net ([72.52.115.56]:46643 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752545Ab0F3W6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:58:17 -0400
Date: Wed, 30 Jun 2010 15:58:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] docbook: use ID as filename
Message-Id: <20100630155812.ff25e97a.rdunlap@xenotime.net>
In-Reply-To: <1277920855.7823.12.camel@jlt3.sipsolutions.net>
References: <1277920855.7823.12.camel@jlt3.sipsolutions.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 20:00:55 +0200 Johannes Berg wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> I'm trying to generate a <set> of <book>s in
> docbook for wireless to link together all the
> cfg80211 and mac80211 documentation.
> 
> However, docbook will generate "re01.html"
> anew for each book for the first <refentry>,
> presumably due to a bug in the stylesheets.
> 
> An effective workaround is to use IDs for the
> filenames, which makes them more descriptive
> as well, e.g. API-enum-ieee80211-band.html.
> 
> Cc: Randy Dunlap <rdunlap@xenotime.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  Documentation/DocBook/stylesheet.xsl |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- wireless-testing.orig/Documentation/DocBook/stylesheet.xsl	2010-06-30 19:57:19.000000000 +0200
> +++ wireless-testing/Documentation/DocBook/stylesheet.xsl	2010-06-30 19:57:23.000000000 +0200
> @@ -6,4 +6,5 @@
>  <param name="callout.graphics">0</param>
>  <!-- <param name="paper.type">A4</param> -->
>  <param name="generate.section.toc.level">2</param>
> +<param name="use.id.as.filename">1</param>
>  </stylesheet>
> 
> 
> --

Applied to my patch queue.  We'll see if it trips up anything.

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
