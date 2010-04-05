Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0DEPYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:24:41 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:56370 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab0DEPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:24:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.34-rc3: Can't insmod after make, because versions now differ?!
Date: Mon, 5 Apr 2010 17:24:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20100405053628.GA12217@elf.ucw.cz>
In-reply-To: <20100405053628.GA12217@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004051724.26225.elendil@planet.nl>
X-OriginalArrivalTime: 05 Apr 2010 15:24:27.0930 (UTC) FILETIME=[14B8EFA0:01CAD4D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Apr  5 07:33:16 amd kernel: udlfb: version magic
> '2.6.34-rc3-00345-ge8240f9-dirty SMP mod_unload CORE2 ' should be
> '2.6.34-rc3-00344-g548fc0a-dirty SMP mod_unload CORE2 '
> 
> Yes, I played with git and recompiled my kernel in order to get new
> module version, but... not even insmod -f works.
> 
> Having to reboot every time I recompile the module or play with git
> makes modules useless for development :-(.

Disable CONFIG_LOCALVERSION_AUTO?
