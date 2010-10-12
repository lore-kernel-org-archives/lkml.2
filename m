Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0JLNc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0JLNc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:32:58 -0400
Date: Tue, 12 Oct 2010 14:32:26 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: Re: dm-crypt: plain64 IV support for -stable?
Message-ID: <20101012133226.GB30719@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Milan Broz <mbroz@redhat.com>
References: <20101012132511.GA24455@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012132511.GA24455@khazad-dum.debian.net>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:25:11AM -0300, Henrique de Moraes Holschuh wrote:
> Would it be possible to add commit 61afef614b013ee1b767cdd10325acae1db1f4d2
> "dm crypt: add plain64 iv" to -stable?
 
I've no objections - it's a simple and safe patch - but technically it's
an enhancement: it's up to the stable maintainers to decide.

Alasdair

