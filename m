Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab2AFCDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:03:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47117 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2AFCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:03:01 -0500
Date: Fri, 6 Jan 2012 06:02:57 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Heikki Krogerus <krohei@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH 1/2] isp1704_charger: fix missing check
Message-ID: <20120106020256.GA21540@oksana.dev.rtsoft.ru>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-2-git-send-email-felipe.contreras@nokia.com>
 <20111208144221.GB25415@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111208144221.GB25415@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 04:42:21PM +0200, Heikki Krogerus wrote:
> On Mon, Dec 05, 2011 at 07:23:39PM +0200, Felipe Contreras wrote:
> > From: Felipe Contreras <felipe.contreras@gmail.com>
> > 
> > A segfault happens if there's no board information.
> > 
> > Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> 
> Acked-by: Heikki Krogerus <krohei@gmail.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
