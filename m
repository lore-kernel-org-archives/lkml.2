Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2H3I77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:59:59 -0400
Received: from mactra.nord-west.net ([91.121.18.19]:58225 "EHLO
	mactra.nord-west.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2H3I75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:59:57 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2012 04:59:56 EDT
Message-ID: <1346316580.7727.1.camel@localhost.localdomain>
Subject: Re: Which disk is ata4?
From: Bjoern Franke <bjo@nord-west.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 30 Aug 2012 10:49:40 +0200
In-Reply-To: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 29.08.2012, 21:38 -0700 schrieb Andy Lutomirski:
> One of my disks went out to lunch for a while.  Logs below.

dmesg | grep ata4

for instance with ata1:
[root@ostrea][/]# dmesg | grep ata1
ata1.00: ATA-7: SAMSUNG MP0402H, UC200-16, max UDMA/100


-- 
xmpp: bjo@schafweide.org
bjo.nord-west.org | nord-west.org | freifunk-ol.de

