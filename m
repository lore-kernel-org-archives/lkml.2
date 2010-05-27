Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab0E0LmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:42:08 -0400
Received: from mga05.intel.com ([192.55.52.89]:5139 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755064Ab0E0LmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:42:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,311,1272870000"; 
   d="scan'208";a="571031574"
Date: Thu, 27 May 2010 11:57:16 +0100
From: Alan Cox <alan@linux.intel.com>
To: Frank Pan <frankpzh@gmail.com>
Cc: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
Message-ID: <20100527115716.76ce299a@linux.intel.com>
In-Reply-To: <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
	<20100526151152.28deaa6c@linux.intel.com>
	<AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is it complex?

You'd have to take that up with the orthographers and historians

> IMHO Rendering non-western languages is nothing
> more than rendering 2 ASCII chars. The current mainline kernel

It is a lot more. Things like arabic vowel handling for example, or
mixed direction text.

> IMHO A user space application doing such thing is just
> re-implementation of virtual terminal support, without the 512
> limitation. Why does we keeping re-inventing the wheel?

Pango does the job. Pango is the wheel.

Kernel code is unpageable, privileged and unable to doing things
trivially like dynamic font management. It's the wrong place for this
kind of stuff because doing fonts right and especially doing language
rendering right is *hard*.

Alan
