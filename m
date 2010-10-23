Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0JWQGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:06:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab0JWQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:06:33 -0400
Date: Sat, 23 Oct 2010 09:06:48 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>,
        Brad Buce <Brad.Buce@elbitsystems-us.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huaxu Wan <huaxu.wan@linux.intel.com>,
        Carsten Emde <C.Emde@osadl.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yong Wang <yong.y.wang@linux.intel.com>,
        Rudolf Marek <r.marek@assembler.cz>
Subject: Re: [66/66] drivers/hwmon/coretemp.c: detect the thermal sensors
	by CPUID
Message-ID: <20101023160648.GA19813@suse.de>
References: <20101022183711.GA23214@kroah.com> <20101022183602.094033497@clark.site> <20101023112732.41a9c3f1@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023112732.41a9c3f1@endymion.delvare>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 11:27:32AM +0200, Jean Delvare wrote:
> On Fri, 22 Oct 2010 11:35:33 -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> Yes, I have an objection. This isn't a bug fix and thus doesn't belong
> to a stable kernel series. Furthermore, this change will let the
> coretemp driver bind to CPU devices it doesn't properly support. Proper
> support for recent CPUs would need commit
> a321cedb12904114e2ba5041a3673ca24deb09c9 (drivers/hwmon/coretemp.c: get
> TjMax value from MSR) which is way too large and intrusive for a stable
> series.
> 
> So please drop this patch from the 2.6.32-stable queue.

Brad, I thought you got Jean's ack for this to be submitted for .32?  If
not, why did you go around the maintainer for this?

Anyway, it's now removed, Jean, thanks for the review, and sorry for the
noise.

greg k-h
