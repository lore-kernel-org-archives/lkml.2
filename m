Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1GVWGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:06:22 -0400
Received: from perninha.conectiva.com.br ([187.115.55.249]:51962 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab1GVWGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:06:21 -0400
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 18:06:20 EDT
Subject: USB 3.0 Hub and USB 3.0 Device
From: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 18:35:48 -0300
Message-ID: <1311370548.16334.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3-1.1mdv2010.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 
I had some problems with USB 3.0 on stable kernels (2.6.38 and 2.6.39)
it does not detect the device. I had to rmmod xhci_hcd && modprobe
xhci_hcd with the device attached on port to detect. And then it works
ok.
It works on 3.0 kernel, but I can't update to it since its not stable
already. I tried to backport the xhci_hcd but it's impossible, its too
much line code. I tried other ugly fixes like removing and loading the
module automatically, but maybe there is another fix.

I tested on current stable branches but no one works well, if there is a
solution please reply me.

Thanks for attention

Alexandre

