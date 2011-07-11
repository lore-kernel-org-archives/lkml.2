Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab1GKQoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:44:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55182 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab1GKQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:44:32 -0400
Date: Mon, 11 Jul 2011 09:44:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@cvml.unipv.it>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - make dmi_check_system return
 immediately when a match is found
Message-ID: <20110711164426.GA1893@core.coreip.homeip.net>
References: <1310395296.2415.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310395296.2415.7.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:41:36PM +0800, Axel Lin wrote:
> We only care about if there is any successful match from the table
> or no match at all, make the dmi_matched callback return 1 then
> dmi_check_system will return immediately if we have a successful match.
> 

This adds too much noise for little gain... With other patches we
already have callbacks defined, so it makes sense it apply them, this one
I think I'll drop.

Thanks.

-- 
Dmitry
