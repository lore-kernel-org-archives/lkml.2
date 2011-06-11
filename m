Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1FKRCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 13:02:45 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:20386 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751146Ab1FKRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 13:02:44 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Fk9GoxEVM1ki0LuFN8z8IJqsdjsZH0nzMYqVyGh8ArDEpVJ
 .gQbh7ttK6BBKuZzUa_EkgTSuq0r8hYfS7wLVONZizILUu11D9XqHJlXs7Zq
 7xJ.jEoGNdIpCa_fQldy8xhQ5OTZJyjLw27gGiOBOrfJf1fHCwnpaRGXdfZ5
 1S2wKlu__rh2jhpJhQ9XJr1kjI.HXizQsChFeGWjR0sg3gC6rmsj0WVrb2Sn
 E5E.LKLhRutcZ0UeW4M0UZQXGXaW7L7rl6w2VIUV5RhO5nZJs51.RvsQNYvg
 04RFD4V.b.bYZuw.paP2UH2MtCIDLc_G90mcU7hLWnxQJZ0LDIjIv
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 11 Jun 2011 12:02:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
In-Reply-To: <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106111202110.32170@router.home>
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <4DF09827.7070809@cs.helsinki.fi> <alpine.DEB.2.00.1106101016420.30968@router.home> <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jun 2011, Pekka Enberg wrote:

> Oh, I don't know - but I definitely need more ACKs to even consider
> pushing this through slab.git.

Any additional ackers out there?;-)

