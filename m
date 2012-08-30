Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab2H3M0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:26:51 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:58926 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214Ab2H3M0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:26:11 -0400
Date: Thu, 30 Aug 2012 14:26:08 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>, yan <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] watchdog: fix a compiler warning of test program
Message-ID: <20120830122608.GW27604@spo001.leaseweb.com>
References: <1346247545-3433-1-git-send-email-clouds.yan@gmail.com> <503E39A5.9090903@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <503E39A5.9090903@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the fix is in Linus his tree also now.

Kind regards,
Wim.

> On 08/29/2012 06:39 AM, yan wrote:
> 
> > This patch fixs the following compiler warning:
> > 
> 
> 
> Hi,
> This is already fixed in the watchdog git tree.
> 
> Thanks.
> 
> > Documentation/watchdog/src/watchdog-test.c:34:6: \
> > warning: no previous prototype for ‘term’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: yan <clouds.yan@gmail.com>
> > ---
> >  Documentation/watchdog/src/watchdog-test.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/watchdog/src/watchdog-test.c b/Documentation/watchdog/src/watchdog-test.c
> > index 73ff5cc..3da8229 100644
> > --- a/Documentation/watchdog/src/watchdog-test.c
> > +++ b/Documentation/watchdog/src/watchdog-test.c
> > @@ -31,7 +31,7 @@ static void keep_alive(void)
> >   * or "-e" to enable the card.
> >   */
> >  
> > -void term(int sig)
> > +static void term(int sig)
> >  {
> >      close(fd);
> >      fprintf(stderr, "Stopping watchdog ticks...\n");
> 
> 
> 
> -- 
> ~Randy
