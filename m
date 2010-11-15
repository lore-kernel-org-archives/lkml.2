Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0KOJJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:09:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0KOJJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:09:53 -0500
Subject: Re: [PATCH] sata-via: enable magic transmission fix for vt6420
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Joseph Chan <JosephChan@via.com.tw>
In-Reply-To: <4CE0B0B8.1010809@garzik.org>
References: <1289737911.24491.7.camel@twins>  <4CE0B0B8.1010809@garzik.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 10:10:02 +0100
Message-ID: <1289812202.2109.475.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 23:02 -0500, Jeff Garzik wrote:
> On 11/14/2010 07:31 AM, Peter Zijlstra wrote:
> > I was able to reproduce and test the transmission error on vt6420
> > hardware with the 2G WD drives. Adding the controller ID to this fix
> > seems to result in a properly working system.
> >
> > Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> 
> Please CC linux-ide and myself on all libata patches, as MAINTAINERS and 
> drivers/ata/sata_via.c both indicate.

Oh, I thought I had CC'ed you, you're in the signoff trail of the
initial patch, I must have fudged it. Sorry about that.
