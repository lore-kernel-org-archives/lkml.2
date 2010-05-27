Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab0E0IFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:05:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:57660 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0E0IFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:05:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 27 May 2010 10:04:53 +0200
Message-ID: <20100527100453.1d55c87e@schatten.dmk.lab>
References: <CEE6BB42CAD6E947908279175AF8470A025A7D7DC4@EXDCVYMBSTM006.EQ1STM.local>
	<Pine.LNX.4.44L0.1005261156130.1328-100000@iolanthe.rowland.org>
	<CEE6BB42CAD6E947908279175AF8470A025A8206ED@EXDCVYMBSTM006.EQ1STM.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: f053210012.adsl.alicedsl.de
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025A8206ED@EXDCVYMBSTM006.EQ1STM.local>
X-Newsreader: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Cc: linux-pm@lists.osdl.org, linux-input@vger.kernel.org,
       linux-omap@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 09:46:51 +0200
Linus WALLEIJ <linus.walleij@stericsson.com> wrote:


> If yes then OK, it's not totally elegant but if that is
> where we have to go, I can live with it. There will likely
> be people who implement for only one or the other semantic
> behaviour, but we have worse things to cope with already.

Alan Cox suggested, that this kind of explicit requirement definition
might be necessary for all drivers anyway in the long run.

That way, the semantic differences between those two cases would
vanish. 

Cheers,
Flo



