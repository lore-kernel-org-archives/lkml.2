Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2GMJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:25:26 -0400
Received: from zep00a03.dent.med.uni-muenchen.de ([138.246.161.8]:46020 "HELO
	md.dent.med.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010Ab2GMJZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:25:25 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2012 05:25:25 EDT
Date: 13 Jul 2012 11:18:43 +0200
Message-ID: <20120713091843.1060.qmail@md.dent.med.uni-muenchen.de>
From: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
To: linux-kernel@vger.kernel.org
Subject: Re: mount -o loop with truncated dosdisk.img uses 100% cpu and can't be killed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe the patch referenced in

http://lkml.indiana.edu/hypermail/linux/kernel/1206.2/02163.html

also relevant in -stable as noted in

 http://lkml.indiana.edu/hypermail/linux/kernel/1206.2/02717.html

is also relevant here?

Regards,
Wolfram.
