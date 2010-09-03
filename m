Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0ICEyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:54:08 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41297 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0ICEyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:54:07 -0400
Date: Fri, 3 Sep 2010 06:54:04 +0200
From: Andreas Mohr <andi@lisas.de>
To: Luke Lowrey <luke@chamsys.co.uk>
Cc: gregkh@suse.de, jhovold@gmail.com, andi@lisas.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Added custom PIDs for ChamSys products
Message-ID: <20100903045404.GB2148@rhlx01.hs-esslingen.de>
References: <1283423989-5710-1-git-send-email-luke@chamsys.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283423989-5710-1-git-send-email-luke@chamsys.co.uk>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 02, 2010 at 11:39:49AM +0100, Luke Lowrey wrote:
> Added the 0xDAF8 to 0xDAFF PID range for ChamSys limited USB interface/wing products
> 
> Signed-off-by: Luke Lowrey <luke@chamsys.co.uk>

I did some ID verification via existing internet information,
patch appears to be correct and nice.

Reviewed-by: Andreas Mohr <andi@lisas.de>

Thank you for your cooperation!

Andreas Mohr
