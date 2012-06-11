Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2FKLSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:18:38 -0400
Received: from r-mail2.rd.francetelecom.com ([217.108.152.42]:27181 "EHLO
	r-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab2FKLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:18:37 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2012 07:18:36 EDT
Message-ID: <4FD5D268.6040503@Free.fr>
Date: Mon, 11 Jun 2012 13:11:36 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2.19 kernel panic does not enter KDB
References: <4FD4837B.5040200@free.fr> <20120610123420.52af4e1a@pyramind.ukuu.org.uk> <4FD48744.3000602@free.fr> <20120611115414.06759ae3@pyramind.ukuu.org.uk>
In-Reply-To: <20120611115414.06759ae3@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2012 11:11:36.0761 (UTC) FILETIME=[F7A4C290:01CD47C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 12:54 PM, Alan Cox wrote:

> kdb not getting entered is not itself a bug - its a limitation.

Ok. I'm still wondering if KDB is not broken on 3.2.19. If on a working 
system I do

echo g > /proc/sysrq-trigger

even from a tty all I see is the help and I'm back to the login shell. 
Actions like

echo t > /proc/sysrq-trigger

are logged but I cannot really enter the debugger...

-- eric


