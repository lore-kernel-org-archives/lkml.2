Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1AMWke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:40:34 -0500
Received: from www.tglx.de ([62.245.132.106]:57161 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1AMWk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:40:28 -0500
Date: Thu, 13 Jan 2011 23:40:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Manoj Iyer <manoj.iyer@canonical.com>
cc: Borislav Petkov <bp@amd64.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
In-Reply-To: <AANLkTi=vyDWT2SBcS-Jh_5xqe4J5OYV8ZSNz=nZAURRu@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101132339370.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6> <20110113172205.GA30866@kryptos.osrc.amd.com> <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com> <20110113175531.GD2006@aftab> <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
 <20110113183025.GE2006@aftab> <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6> <20110113185807.GA24720@srcf.ucam.org> <20110113190700.GB30866@kryptos.osrc.amd.com> <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
 <20110113192825.GC30866@kryptos.osrc.amd.com> <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6> <AANLkTi=iE5FTErH+KBf+NB13wThpODCjqfj7vZ=wPtir@mail.gmail.com> <AANLkTi=2+jpMYP4X+yLQ0cH4oqaUPvX-c8pd821fF1-v@mail.gmail.com>
 <alpine.LFD.2.00.1101132232310.2678@localhost6.localdomain6> <AANLkTi=vyDWT2SBcS-Jh_5xqe4J5OYV8ZSNz=nZAURRu@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Manoj Iyer wrote:

> Thomas,
> 
> Attached are 2 dmesg outputs
> 
> 1. dmesg output after boot with the patch applied.
> 2. dmesg output after suspend/resume with patch applied.

I don't see any of the pr_debug printks at all.
