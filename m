Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1JARkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:40:13 -0400
Received: from lo.gmane.org ([80.91.229.12]:48978 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1JARkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:40:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dick <dick@mrns.nl>
Subject: Re: efilinux release 0.8
Date: Sat, 1 Oct 2011 17:36:29 +0000 (UTC)
Message-ID: <loom.20111001T192449-587@post.gmane.org>
References: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 80.56.144.252 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.237 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming <matt <at> console-pimps.org> writes:
> If anyone has the time and inclination I'd really appreciate it if they
> could have a play with it on their machines and report any bugs.

Latitude E6510 (Intel 45 Express chipset, UEFI can start efilinux.efi (I get the 
usage output) but when I load a kernel it get stuck after a message about the 
kernel is being loaded.

I'm using the (old) shell (EdkShellBinPkg) from tianocore(.sf.net) to start 
efilinux.efi because the Dell BIOS setup utility can't add parameters to an EFI 
executable.

