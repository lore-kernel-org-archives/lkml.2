Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0F3PUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:20:13 -0400
Received: from client-adsl-93-121-138-180.mediaserv.net ([93.121.138.180]:37412
	"EHLO werner.loopback" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753822Ab0F3PUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:20:11 -0400
X-Greylist: delayed 137404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2010 11:20:11 EDT
From: werner@guyane.yi.org
Subject: Problem HIGHMEM64, PAE
To: linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1277527909.7349@guyane.yi.org>
Date: Sat, 26 Jun 2010 01:51:49 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1277527909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1277527909
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

On 02/Mar/2010 03:01 werner@guyane.dyn-o-saur.com wrote ..
> I posted some time ago that there exists the problem that HIGHMEM64 and PAE mode
> cannot be switched off -- so that these kernels don't run on old computers.
> 
> After long time, ocasionally I found that one have to switch off CONFIG_X86_32_NON_STANDARD
> .
> 
> I suggest to write this inside the help text for HIGHMEM64, because I suppose that
> other persons have the same problem.
> 
> Anyway it's posted here so that, by searching on  internet, people can find this
> information.
> 
> W.Landgraf

--bound1277527909--

