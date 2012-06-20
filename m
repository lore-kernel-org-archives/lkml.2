Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2FTHKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:10:14 -0400
Received: from nbd.name ([46.4.11.11]:53096 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab2FTHKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:10:12 -0400
Message-ID: <4FE1771A.8070703@phrozen.org>
Date: Wed, 20 Jun 2012 09:09:14 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Yoichi Yuasa <yuasa@linux-mips.org>
CC: linux-kernel@vger.kernel.org, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] MIPS: fix bug.h MIPS build regression
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org>        <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com> <20120620152759.2caceb8c.yuasa@linux-mips.org>
In-Reply-To: <20120620152759.2caceb8c.yuasa@linux-mips.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/12 08:27, Yoichi Yuasa wrote:
> Commit: 3777808873b0c49c5cf27e44c948dfb02675d578 breaks all MIPS builds.
> 

Hi Yoichi,

I stumbled across the same build regression last night and came up with
almost the same fix :-)

Tested-by: John Crispin <blogic@openwrt.org>

Thanks,
John
