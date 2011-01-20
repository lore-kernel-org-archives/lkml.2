Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1ATUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:02:20 -0500
Received: from kroah.org ([198.145.64.141]:47303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1ATUCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:02:18 -0500
Date: Thu, 20 Jan 2011 11:52:54 -0800
From: Greg KH <greg@kroah.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>
Subject: Re: [PATCH 2/2] staging: tidspbridge: replace mbox callback with
 notifier_call
Message-ID: <20110120195254.GA1730@kroah.com>
References: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
 <1294983293-10177-3-git-send-email-omar.ramirez@ti.com>
 <AANLkTinG5tQJ=aFHJDcLJnWX7RF3Jjru_pUqXXn4=wue@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinG5tQJ=aFHJDcLJnWX7RF3Jjru_pUqXXn4=wue@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 04:53:25PM -0600, Ramirez Luna, Omar wrote:
> On Thu, Jan 13, 2011 at 11:34 PM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> > Lately, mailbox callbacks have been replaced by notifier block
> > call chains, this needs to be changed in the users of mailbox,
> > otherwise compilation will break due to missing parameters.
> 
> Please hold on applying this patch, it is not right as io_mbx_msg
> differs on what a notifier_call parameters and type should be.

Ok, I'll just queue up the 1st patch in this series.

greg k-h
