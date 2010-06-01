Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0FALTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:19:16 -0400
Received: from mail.netservers.co.uk ([80.248.178.71]:49245 "EHLO
	mail.netservers.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0FALTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:19:13 -0400
X-Envelope-From: ben@netservers.co.uk
Message-ID: <4C04ECA3.1080905@netservers.co.uk>
Date: Tue, 01 Jun 2010 12:18:59 +0100
From: Ben McKeegan <ben@netservers.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Richard Hartmann <richih.mailinglist@gmail.com>
CC: Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 	multi-link
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>	<4BACE827.4070006@gmail.com>	<20100326170428.6c1ad66c@lxorguk.ukuu.org.uk>	<4BB31E00.8060204@netservers.co.uk>	<20100529021624.GA2538@brick.ozlabs.ibm.com> <AANLkTil7fk_ikrSPiZnqcJSLGCrzcCrCwbeuUMY5Yu5v@mail.gmail.com>
In-Reply-To: <AANLkTil7fk_ikrSPiZnqcJSLGCrzcCrCwbeuUMY5Yu5v@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hartmann wrote:

> As 2.6.35-rc1 is out, does this mean that we are looking at 2.6.36 at the
> earliest? Or could this make it in as it is
> 
> a) a bug fix

This isn't really a bug fix.  Its a behavioural change to work around 
poor quality/mismatched underlying PPP channels.

Regards,
Ben.
