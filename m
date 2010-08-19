Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0HSNFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:05:23 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5198 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab0HSNFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:05:20 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7JD5Dxb014063
Subject: Re: [RFC][PATCH] introduce ptr_diff()
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100819125957.GB6729@basil.fritz.box>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
	 <87aaoiu6z6.fsf@basil.nowhere.org> <1282222109.10440.50.camel@thorin>
	 <20100819125957.GB6729@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 15:05:13 +0200
Message-ID: <1282223113.10440.78.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2010-08-19 at 14:59 +0200, Andi Kleen wrote:
> > If so, the warning seems valid as sizeof(struct page) is probably not
> > (always) a power of 2. On a native build on x86_64 it is 56 bytes
> > hereover.
> > Hmm ....
> 
> gcc just generats a mull with inverted value. mull is cheap on any
> reasonable CPU.  Please fix sparse.

Not that I really know the code of sparse but what would be an
acceptable condition (except plain simply disabling/removing the warning
as such)?
No warning if it's a constant value (read: explicit or sizeof())?

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

