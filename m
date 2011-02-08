Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1BHPPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:15:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46539 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1BHPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sfq6HiLYPYizVDEtbwgYLoHKKIkojjDNAOxoYazgCnT3OFY/ds80hMa9gW2nhgD1uv
         PYQf3IfgpoQy/+ciEZ+7wlvl3B9U+WPHH0a8sOXwdg1zpFCFhH+Zn5zryQyQT/R8Rpyv
         q85ebNLEouJYnIwGb+RdULjYp674s+n1hWCA4=
Date: Tue, 8 Feb 2011 16:14:53 +0100
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH wq#for-2.6.39] workqueue: add
 system_freezeable_wq
Message-ID: <20110208151453.GC6558@htj.dyndns.org>
References: <20110208094155.GB6558@htj.dyndns.org>
 <Pine.LNX.4.44L0.1102081008180.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1102081008180.2100-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 10:10:46AM -0500, Alan Stern wrote:
> On Tue, 8 Feb 2011, Tejun Heo wrote:
> 
> > From de62c151df9b6568c67977920267392c432f340a Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Tue, 8 Feb 2011 10:39:03 +0100
> > 
> > Add system wide freezeable workqueue.
> 
> The preferred spelling is "freezable".

Hmmm... workqueue always has used freezeable (even before cmwq
changes).  It seems like mass renaming is in order.  :-(

Thanks.

-- 
tejun
