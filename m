Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1F2GZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:25:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41326 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1F2GY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:24:56 -0400
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Wed, 29 Jun 2011 09:25:47 +0300
In-Reply-To: <4E09F3F1.7080109@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
		<1308922482-14967-2-git-send-email-david.wagner@free-electrons.com>
		<1309202771.24805.11.camel@koala> <4E09EA52.8090006@parrot.com>
	 <4E09F3F1.7080109@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309328751.23597.109.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 17:32 +0200, David Wagner wrote:
> On 06/28/2011 04:50 PM, Matthieu CASTET wrote:
> > Hi,
> >
> [...]
> > Also what are the advantage against gluebi + mtdblock_ro ?
> 
> The main advantage is a reduced number of layers ; I must say I cannot
> see much more for now.  I could add that the Kconfig help of gluebi
> advises not to use it except when needed by legacy software.

Well, I think Matthieu has a valid poit, you should try to come up with
a set of advantages, otherwise why would this drivers be needed? Why
would people spend time reviewing it? May be less memcpy's? Do we do an
extra memcpy in gluebi? If yes, can we avoid doing this. Anyway, please,
try to sell this driver a bit better.

-- 
Best Regards,
Artem Bityutskiy

