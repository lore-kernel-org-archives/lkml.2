Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1EBGzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:55:10 -0400
Received: from eazy.amigager.de ([213.239.192.238]:57952 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1EBGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:55:07 -0400
Date: Mon, 2 May 2011 08:55:29 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: unable to handle kernel paging request when inserting FAT32
 formatted flash media
Message-ID: <20110502065529.GA12397@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <20110502064945.GA12197@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502064945.GA12197@mac.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 08:49:45 +0200, Tino Keitel wrote:
> Hi,
> 
> when I insert a CF or SD card from my cameras into the USB card reader,
> I get the attached kernel oops. This is reproducible and did not happen
> with 2.6.38.

Forgot to mention: the bug occurs with 2.6.39-rc5.

Regards,
Tino
