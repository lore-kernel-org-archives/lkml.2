Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HWUad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:30:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54017 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab1HWUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:30:27 -0400
X-Sasl-enc: QE6F+HuopeM+LBoOEvgBgBYLhroivHq7cJivTSQ/YEss 1314131426
Date: Tue, 23 Aug 2011 13:25:36 -0700
From: Greg KH <greg@kroah.com>
To: Toon Schoenmakers <nighteyes1993@gmail.com>
Cc: acho@novell.com, randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: staging: keucr: fix most of the errors/warnings from checkpatch
Message-ID: <20110823202536.GA1513@kroah.com>
References: <1310851799.4191.2.camel@Rarity>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310851799.4191.2.camel@Rarity>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 11:29:59PM +0200, Toon Schoenmakers wrote:
> From: Toon Schoenmakers <nighteyes1993@gmail.com>
> 
> Fixed most of the warnings and errors
> 
> Signed-off-by: Toon Schoenmakers <nighteyes1993@gmail.com>

This broke the build, please test your patches after making them and
before sending them out :(

ugh,

greg k-h
