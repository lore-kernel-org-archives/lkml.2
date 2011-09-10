Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab1IJLaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 07:30:05 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40885 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab1IJLaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 07:30:04 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Jonas Bonn <jonas.bonn@gmail.com>
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
Date: Sat, 10 Sep 2011 12:29:57 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>,
        Richard Kuo <rkuo@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
References: <20110909010847.294039464@codeaurora.org> <20110909211808.GA3150@codeaurora.org> <CACM3HyH8P=u9pR0sa2besxsgDN5TUKg_7utLJTwL+hu8Wv48ow@mail.gmail.com>
In-Reply-To: <CACM3HyH8P=u9pR0sa2besxsgDN5TUKg_7utLJTwL+hu8Wv48ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109101229.58445.pedro@codesourcery.com>
X-OriginalArrivalTime: 10 Sep 2011 11:30:01.0255 (UTC) FILETIME=[FA5FEB70:01CC6FAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 07:42:26, Jonas Bonn wrote:

> I'm really not an expert on GDB, but I believe it can use either the
> PEEK/POKE functions to access regs, or it can use GET/SETREGS; it's an
> architecture-dependent configuration.  I think the second variant can
> be easily modified to become GET/SETREGSET instead, and the PEEK/POKE
> variant wouldn't be needed at all.

Yes, the x86/x86-64 ports or gdb and gdbserver are already
using GET/SETREGSET even.

-- 
Pedro Alves
