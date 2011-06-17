Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1FQGzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 02:55:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56702 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FQGzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 02:55:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 17 Jun 2011 08:55:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Message-ID: <20110617085521.3f66fe59@stein>
In-Reply-To: <1308264321.2436.161.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	<20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	<20110615153337.GA10160@kroah.com>
	<4DF9F11F.705@hitachi.com>
	<20110616154129.GA31498@kroah.com>
	<1308239454.2436.34.camel@mulgrave>
	<20110616161442.GA32113@kroah.com>
	<1308241506.2436.44.camel@mulgrave>
	<20110616181943.GB1439@kroah.com>
	<1308256290.2436.143.camel@mulgrave>
	<BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
	<1308264321.2436.161.camel@mulgrave>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16 James Bottomley wrote:
> I agree that all the output tools within reason can be
> fixed to do this automatically, but fixing cat say, just so
> cat /proc/partitions works would never be acceptable upstream.

There is an alternative to cat, called sed, which already carries the fix. :-)
-- 
Stefan Richter
-=====-==-== -==- =---=
http://arcgraph.de/sr/
