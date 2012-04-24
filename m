Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2DXGAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:00:42 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:38871 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2DXGAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:00:40 -0400
Date: Mon, 23 Apr 2012 23:00:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: George Pantalos <gpantalos@gmail.com>, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ALPS - Add semi-MT support for v4 protocol
Message-ID: <20120424060033.GA28958@core.coreip.homeip.net>
References: <1753794.1syzYofK8B@vaio>
 <20120418133823.GA31655@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418133823.GA31655@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 08:38:23AM -0500, Seth Forshee wrote:
> On Wed, Apr 18, 2012 at 02:02:14AM +0300, George Pantalos wrote:
> > This patch adds semi-MT support for ALPS v4 protocol touchpads.
> > It is based on the work by Seth Forshee for ALPS v3 and v4 protocol
> > support. Three packets are required to assemble and process the MT
> > data. ST events are reported at once to avoid latency. If there
> > were two contacts or more, report MT data instead of ST events.
> > 
> > Thanks to Seth Forshee for providing most of the code, guidance
> > and insight for producing this patch.
> > 
> > Signed-off-by: George Pantalos <gpantalos@gmail.com>
> 
> Acked-by: Seth Forshee <seth.forshee@canonical.com>

Applied, thank you George, Seth.

-- 
Dmitry
