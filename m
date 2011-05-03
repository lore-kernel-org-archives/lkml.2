Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1ECUVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:21:48 -0400
Received: from eazy.amigager.de ([213.239.192.238]:49998 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab1ECUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:21:47 -0400
Date: Tue, 3 May 2011 22:22:08 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: unable to handle kernel paging request when inserting FAT32
 formatted flash media
Message-ID: <20110503202208.GA5666@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <20110502064945.GA12197@mac.home>
 <20110502065529.GA12397@mac.home>
 <87y62pf9xg.fsf@devron.myhome.or.jp>
 <87r58hf866.fsf@devron.myhome.or.jp>
 <20110502170122.GA14096@eazy.amigager.de>
 <87k4e9ey9k.fsf@devron.myhome.or.jp>
 <20110502203327.GA19507@mac.home>
 <87bozkg3ng.fsf@devron.myhome.or.jp>
 <8762psfwew.fsf@devron.myhome.or.jp>
 <871v0gfw9z.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871v0gfw9z.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:44:08 +0900, OGAWA Hirofumi wrote:

[...]

> BTW, rebuilding from scratch make something difference?

Hi,

I upgraded to current git (5933f2ae353a93b1d3b501bc63c925531849bbc7),
and did a git clean -dfx. The rebuilt kernel now does not Oops anymore,
with both the CF and the SD card. Could this be a glitch in the
Makefile dependencies?

Regards,
Tino
