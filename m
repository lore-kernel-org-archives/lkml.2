Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1BJNPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:15:20 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:41524 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1BJNPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:15:18 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
Date: Thu, 10 Feb 2011 15:15:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-ARCH; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20110209195258.GN11874@hexapodia.org> <20110209232302.GS11874@hexapodia.org> <201102101424.59128.lasse.collin@tukaani.org>
In-Reply-To: <201102101424.59128.lasse.collin@tukaani.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101515.08803.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-10 Lasse Collin wrote:
> It looks a like a bug in dash. The following with dash prints foo bar
> and returns with exit status 0, but other shells print only foo and
> return with non-zero exit status:
> 
>     sh -c 'set -e ; echo foo ; ( false ) ; echo bar'

This dash bug has been fixed on 2010-07-06.

http://git.kernel.org/?p=utils/dash/dash.git;a=commitdiff;h=a92255d6fa8b8efb0f9fb093b77ac601fe3e9ede

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
