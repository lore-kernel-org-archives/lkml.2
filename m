Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1IKKPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 06:15:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44236 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1IKKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:15:49 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Sun, 11 Sep 2011 13:18:12 +0300
In-Reply-To: <4E6A25B1.8070400@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
		 <1315280704.19067.14.camel@sauron> <1315282208.19067.24.camel@sauron>
		 <201109081726.00769.arnd@arndb.de> <1315569206.7905.41.camel@sauron>
	 <4E6A25B1.8070400@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315736297.18731.1.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:41 +0200, David Wagner wrote:
> > 1. Stick with the own cdev approach - the driver becomes very simple
> >    in this case - we review it.
> 
> This is the way it's implemented in v4, right ? 

Yes, but I though I sent you some feed back with minor things as well as
with major issue related to race condigions: you should keep the UBI
volume open as long as your block device is referenced, to prevent the
UBI volume from being removed.

-- 
Best Regards,
Artem Bityutskiy

