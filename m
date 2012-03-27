Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab2C0HeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:34:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59791 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2C0HeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:34:06 -0400
Date: Tue, 27 Mar 2012 00:33:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: linux-next: manual merge of the input tree with Linus' tree
Message-ID: <20120327073358.GD1521@core.coreip.homeip.net>
References: <20120327121610.e39e648811d5b00ae328077b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327121610.e39e648811d5b00ae328077b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Mar 27, 2012 at 12:16:10PM +1100, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> drivers/input/tablet/wacom_sys.c between commit 24e3e5ae1e4c ("Input:
> wacom - fix physical size calculation for 3rd-gen Bamboo") from Linus'
> tree and commit 16bf288c4be6 ("Input: wacom - create inputs when wireless
> connect") from the input tree.
> 
> The latter seems to incorporate the former, so I used that.

Thank you. I merged the branches and resolved conflict so you should not
see it anymore.

Thanks.

-- 
Dmitry
