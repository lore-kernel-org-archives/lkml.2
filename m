Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0FDIct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:32:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0FDIcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:32:48 -0400
Message-ID: <4C08BA2D.3010108@suse.cz>
Date: Fri, 04 Jun 2010 10:32:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] scripts: decodecode: use /bin/bash
References: <1275581686-19745-1-git-send-email-rabin@rab.in> <20100603092458.d0d603e3.randy.dunlap@oracle.com> <20100603171812.GA23367@debian>
In-Reply-To: <20100603171812.GA23367@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.6.2010 19:18, Rabin Vincent wrote:
> From f729122bcd237f32c9f667e5644c6114ddc795af Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Thu, 3 Jun 2010 21:33:46 +0530
> Subject: [PATCH] scripts: decodecode: remove bashisms
> 
> Remove bashisms to make scripts/decodecode work with other shells.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Thanks, applied.

Michal
