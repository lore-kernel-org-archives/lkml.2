Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1BHRk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:40:26 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53111 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1BHRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:40:25 -0500
Date: Tue, 8 Feb 2011 09:40:20 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, jon.nettleton@gmail.com,
        linux-kernel@vger.kernel.org, cjb@laptop.org
Subject: Re: [PATCH RFC] staging: olpc_dcon: Remove _strtoul() function.
Message-ID: <20110208094020.44f0fe88@queued.net>
In-Reply-To: <20110208112354.GN4384@bicker>
References: <1297163160-23429-1-git-send-email-marek.belisko@open-nandra.com>
	<20110208112354.GN4384@bicker>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011 14:23:54 +0300
Dan Carpenter <error27@gmail.com> wrote:

> On Tue, Feb 08, 2011 at 12:06:00PM +0100, Marek Belisko wrote:
> > olpc_dcon driver use self invented _strtoul  function
> > which make similar check like strict_strtoul just extend
> > for space checking at last string place. Normally access
> > to sys file looks echo 1024 > /sys/... so space could be considered
> > as error character and we could simplify code using just
> > strict_strtoul function instead self invented.
> > 
> 
> Could you do it on top of the patches that Andres Salomon sent?
> 

Actually, I have more pending patches.  I can add this to the patchset
and send it later.  Greg, please don't merge it now, though.
