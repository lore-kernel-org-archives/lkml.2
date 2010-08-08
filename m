Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0HHKnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 06:43:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:56783 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0HHKnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 06:43:24 -0400
Date: Sun, 8 Aug 2010 19:43:19 +0900
To: janos.haar@netcenter.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: scsi emulation - question
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <026c01cb361c$3c895b10$0400a8c0@dcccs>
References: <0f7601cb35be$d93998c0$0400a8c0@dcccs>
	<20100808174914A.fujita.tomonori@lab.ntt.co.jp>
	<026c01cb361c$3c895b10$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100808194212O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 08 Aug 2010 19:43:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010 12:35:14 +0200
"Janos Haar" <janos.haar@netcenter.hu> wrote:

> But now i have readed the documentation, and for me it looks like scsi-debug 
> can work only in RAM and can make only volatile drives.

Yes. If you store data to a file, a device, etc, iSCSI is the only
option.
