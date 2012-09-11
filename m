Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2IKIFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:05:54 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:30269 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207Ab2IKIFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:05:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFANTvTlBtgrJV/2dsb2JhbABFhgeyB4NAgQiCIAEBBSMzMwsOCgICJgICFCUkAYgmqGWTMYEhiW+FFDJgA5VckB6CaA
Date: Tue, 11 Sep 2012 10:05:35 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3] can: rename LED trigger name on netdev renames
Message-ID: <20120911080535.GA412@vandijck-laurijssen.be>
Mail-Followup-To: Oliver Hartkopp <socketcan@hartkopp.net>,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142827.GB11000@vandijck-laurijssen.be>
 <504E30AE.50201@hartkopp.net>
 <20120910184049.GD2006@gmail.com>
 <504E3901.10901@hartkopp.net>
 <20120910200844.GC546@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910200844.GC546@vandijck-laurijssen.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:08:44PM +0200, Kurt Van Dijck wrote:
> On Mon, Sep 10, 2012 at 09:01:21PM +0200, Oliver Hartkopp wrote:
> > On 10.09.2012 20:40, Fabio Baltieri wrote:
> > 
> > > On Mon, Sep 10, 2012 at 08:25:50PM +0200, Oliver Hartkopp wrote:
> > >> On 10.09.2012 16:28, Kurt Van Dijck wrote:
> > >>> Fabio,
> > >>>
> > > 
> > > Also, I noticed you removed the namespace check... wasn't it needed?
> > > (just asking, I have no idea).
> 

Moreover, the function tests if the net_device has an associated can_priv.
The namespace it's in is irrelevant then?
I think those tests may be removed in af_can too.

Kurt
