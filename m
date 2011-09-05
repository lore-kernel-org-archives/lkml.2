Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1IEMeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:34:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:45614 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1IEMeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:34:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: Linux as Bootloader
Date: Mon, 5 Sep 2011 12:33:41 +0000 (UTC)
Message-ID: <loom.20110905T143000-518@post.gmane.org>
References: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.139.81.4 (Mozilla/5.0 (Windows NT 5.1; rv:6.0.1) Gecko/20100101 Firefox/6.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Gmeiner <christian.gmeiner <at> gmail.com> writes:

> 
> Hi all,
[...]
> Now I run in some troubles as I need to be able to boot a MSDOS
> application stored on
> an usb stick. [...]
> Are there some creative/working solutions for my problem?
> 

How about some DOS emulator (e.g. DosEmu or DosBox) (if you really
have to run DOS program(s) and absolutely can't recompile/rewrite it for 
Linux...) - but if you need low-level hw access I think you'd better
create a kernel module...

> thanks
> --
> Christian Gmeiner, MSc
> 

L.


