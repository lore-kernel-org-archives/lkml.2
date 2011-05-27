Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab1E0JJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:09:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:21499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1E0JJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,279,1304319600"; 
   d="scan'208";a="9848763"
Date: Fri, 27 May 2011 09:56:07 +0100
From: Alan Cox <alan@linux.intel.com>
To: Michael Chang <mchang@novell.com>
Cc: Greg KH <gregkh@suse.de>, error27@gmail.com, justinmattock@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/gma500: get control from firmware framebuffer
 if conflicts
Message-ID: <20110527095607.5b0b0b7a@bob.linux.org.uk>
In-Reply-To: <BANLkTi=DYt-Y=151knsQBjBaEJfjqn4ciQ@mail.gmail.com>
References: <BANLkTi=DYt-Y=151knsQBjBaEJfjqn4ciQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We should let psbfb takeover framebuffer control from vesafb
> to get around this problem.

Looks good to me assuming we have stolen memory. This maybe wants to
test

	if (pg->stolen_size)

although I'm not sure that adding a zero size aperture would do harm
any way ? The devices without stolen ram also won't have vesa.

Alan
