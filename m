Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0CZRAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:00:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51900 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752082Ab0CZRAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:00:34 -0400
Date: Fri, 26 Mar 2010 17:04:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP
 multi-link
Message-ID: <20100326170428.6c1ad66c@lxorguk.ukuu.org.uk>
In-Reply-To: <4BACE827.4070006@gmail.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<4BACE827.4070006@gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 22:00:23 +0500
"Alexander E. Patrakov" <patrakov@gmail.com> wrote:

> 26.03.2010 21:02, Alan Cox wrote:
> 
> > You can then do this
> >
> > static int ml_explode = 1;
> > module_param(ml_explode, int, 0600);
> > MODULE_PARM_DESC(ml_expode, "Set this to zero to disabling multilink \
> > 	fragmentation when talking to cisco devices");
> >
> > which will let you load the module with the option ml_explode = 0 if you
> > want that property.
> >
> > Making it runtime per link selectable would be nicer but thats a bit more
> > work.
> 
> Doesn't it work already via echoing values to 
> /sys/module/ppp/generic/parameters/ml_explode in the above code?

Thats runtime (and why I set 0600 in the permissions for the example) but
not per link.

Alan
