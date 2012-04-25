Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2DYPeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:34:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57392 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2DYPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120425144452.32a803fe@notabene.brown>
References: <20120425124925.267056b5@ubuntu> <20120425132122.11280b66@notabene.brown>
 <20120425142001.2cb7a79e@ubuntu> <20120425144452.32a803fe@notabene.brown>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Apr 2012 09:34:23 -0600
Message-ID: <CAErSpo7KCJ8osWUH_TLc9adwfjLkqgQbUer6wouT09XFYH3=Zg@mail.gmail.com>
Subject: Re: 3.1+ kernels unbootable
To: NeilBrown <neilb@suse.de>
Cc: Chris Jones <chrisjones@spin.net.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You might be seeing nothing because of the distro splash screen, so
you could try removing any boot options like "silent splash quiet
rhgb" and adding "debug ignore_loglevel" and maybe "vga=0xf07" (to get
more text on the screen).  If you learn anything that way, maybe you
could collect a dmesg log from the newest working kernel and a digital
photo of the broken one for comparison.

Bjorn
