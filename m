Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2FMLeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:34:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49689 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753436Ab2FMLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:34:08 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+is7M1MPCiexBazuMYv0hrpfWgSSnt/vPvsoBgOz
	W7dWFOzcIhaqMU
Date: Wed, 13 Jun 2012 13:34:03 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Jussi Maki <joamaki@gmail.com>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: fanotify hangs with multi-threaded programs
Message-ID: <20120613113403.GA2852@Neptun>
References: <CAHn8xck=gL34Ht7nngiRJwOvRPz_pMCc5ySGYb_eCG073kzVpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHn8xck=gL34Ht7nngiRJwOvRPz_pMCc5ySGYb_eCG073kzVpw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent a patch some time ago that should fix this issue
(see http://marc.info/?l=linux-fsdevel&m=133246703731488&w=2).
I think its in linux-next now.

Lino
