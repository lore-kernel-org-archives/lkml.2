Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0EQNaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:30:17 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39304 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab0EQNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:30:15 -0400
X-IronPort-AV: E=Sophos;i="4.53,247,1272837600"; 
   d="scan'208";a="51302526"
Date: Mon, 17 May 2010 15:30:12 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Srinivas Nayak <sinu.nayak2001@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Which function returns LWP in Linux.
Message-ID: <20100517133012.GC26359@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Srinivas Nayak <sinu.nayak2001@gmail.com>,
	Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
	linux-kernel@vger.kernel.org
References: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com> <20100517160319.A195.A69D9226@jp.fujitsu.com> <AANLkTik2OcSBGdkRQKFl6xh06PEr7Al6xaUsmMGGC6jo@mail.gmail.com> <AANLkTilGLJJG_eLHaqvJ5jOzxp96SbOroTCbHe9g5TXE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilGLJJG_eLHaqvJ5jOzxp96SbOroTCbHe9g5TXE@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivas Nayak, le Mon 17 May 2010 15:43:17 +0530, a écrit :
> After some more research, i foind that
> 
> syscall(SYS_gettid)
> 
> returns LWP id. Isn't this correct?

It is correct only on Linux, but yes.

Samuel
