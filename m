Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2LSR7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:59:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49152 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2LSR7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:59:05 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2 v3] menuconfig: Add Save/Load buttons
Date: Wed, 19 Dec 2012 18:58:54 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
References: <20121219015058.GA5488@udknight>
In-Reply-To: <20121219015058.GA5488@udknight>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212191858.54659.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Wednesday 19 December 2012 Wang YanQing wrote:
> If menuconfig have Save/Load button like alternative
> .config editors, xconfig, nconfig, etc.We will have
> a obvious benefit when use menuconfig just like
> when we use others, we can Save/Load our .config quickly
> and conveniently.
> 
> This patch add the Save/Load button for menuconfig.
> 
> [remove trailing space while at it for below line:
> "*)  Formerly when I used Page Down and Page Up, the cursor would be set"
> ]
> 
> Changes:
> V1-V2:
> 1:use PATH_MAX instead of hard code suggested by Yann E. MORIN
> 2:drop the spurious empty-line removal suggested by Yann E. MORIN
> V2-V3:
> 1:ajust buttons position well centered reported by Yann E. MORIN
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Reviewd-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

