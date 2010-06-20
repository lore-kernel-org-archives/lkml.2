Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0FTPBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 11:01:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0FTPBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 11:01:05 -0400
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
  Enable Online Controller Reset Bit in register related functions
From: James Bottomley <James.Bottomley@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 10:01:00 -0500
Message-ID: <1277046060.5242.18.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 14:18 -0700, Yinghai Lu wrote:
> On Wed, Jun 9, 2010 at 7:34 PM, Yang, Bo <Bo.Yang@lsi.com> wrote:
> > Enable the Online Controller reset bit in the register related functions.  This is first part of the Online Controller Reset.
> > The driver supports XScle and Gen2 chips.  Driver need to read the FW state register to see if there is FW state change
> > Happen.
> >
> > Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> This patch cause kernel hang just after
> [  136.996297] megasas: FW now in Ready state

OK, I dropped all the megaraid_sas patches for now ... I'll reapply once
we get the bisection intervals sorted out.

James


