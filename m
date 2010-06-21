Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0FULnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:43:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab0FULnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:43:45 -0400
Date: Mon, 21 Jun 2010 13:43:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Micki Balanga <micki@n-trig.com>
Cc: chatty@enac.fr, dhprince-devel@yahoo.co.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rafi Rubin <rafi@seas.upenn.edu>
Subject: RE: [PATCH] HID: Add support to new N-trig firwmare
In-Reply-To: <48A28051AC6D7A48B64F282724581903382885@Exchange-IL.n-trig.com>
Message-ID: <alpine.LNX.2.00.1006211342580.13809@pobox.suse.cz>
References: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com> <alpine.LNX.2.00.1006041115480.12271@pobox.suse.cz> <48A28051AC6D7A48B64F28272458190326E03E@Exchange-IL.n-trig.com> <alpine.LNX.2.00.1006051741361.12271@pobox.suse.cz>
 <48A28051AC6D7A48B64F28272458190338280A@Exchange-IL.n-trig.com> <alpine.LNX.2.00.1006211143520.13809@pobox.suse.cz> <48A28051AC6D7A48B64F282724581903382885@Exchange-IL.n-trig.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Micki Balanga wrote:

> Attach one file which update hid_blacklist.
> Attach Second patch which update ntrig_devices.

I have folded the patches together, rebased them on top of the patch you 
already sent me and I had in my tree (adding devices up od 0x0A), and 
applied. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
