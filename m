Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0KSBFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:05:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1560 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0KSBFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:05:10 -0500
Subject: Re: [PATCH] SuperH IrDA: correct Baud rate error correction
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Nicolas Kaiser <nikai@nikai.net>, Samuel Ortiz <samuel@sortiz.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        irda-users@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101118164150.22aa7e16@nehalam>
References: <20101119012402.43e9aa61@absol.kitzblitz>
	 <20101118164150.22aa7e16@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 17:05:04 -0800
Message-ID: <1290128704.1817.56.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 16:41 -0800, Stephen Hemminger wrote:
> On Fri, 19 Nov 2010 01:24:02 +0100
> Nicolas Kaiser <nikai@nikai.net> wrote:
> >  	u32 rate_err_array[] = {
> > -		0000, 0625, 1250, 1875,
> > +		   0,  625, 1250, 1875,
> >  		2500, 3125, 3750, 4375,
> >  		5000, 5625, 6250, 6875,
> >  		7500, 8125, 8750, 9375,
> While you are at it make that table const.

Good find Nicolas.

static const might be better still.


