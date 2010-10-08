Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0JHSPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:15:13 -0400
Received: from mail.atheros.com ([12.19.149.2]:64673 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab0JHSPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:15:11 -0400
Date: Fri, 8 Oct 2010 11:15:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Suraj Sumangala <Suraj.Sumangala@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
Message-ID: <20101008181508.GM10149@tux>
References: <20101008170258.GJ10149@tux>
 <4CAF5488.3030706@Atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CAF5488.3030706@Atheros.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:27:36AM -0700, Suraj Sumangala wrote:
> Hi Luis,
> 
> On 10/8/2010 10:32 PM, Luis Rodriguez wrote:
> > Suraj,
> >
> > What is the difference between ath3k-2.fw and ath3k-1.fw ?
> 
> This is the same question for which I have been trying to get an answer.
> The only information that I got was it fixes some critical bug and 
> support shared antenna.
> 
> If ath3k-2.fw is an upgrade of ath3k-1.fw why do we need to name it 
> differently?

Sure, agreed, but what about the sflash configuration fix?

> > Won't the API change now that you are addressing the sflash
> > configuration fix? Would it not help to identify the two
> > different firmwares then?
> >
> > David, Marcel, what are your preferences for a firmware upgrade
> > where the firmware does not change API (lets just pretend it does
> > not for a moment) ? Do we keep the same filename?
> 
> Marcel had answered me before. It makes sense to have same file name.
> Other ways we end up changing the driver whenever there is a firmware 
> change.

> > I last tried to document a thread we had over this here:
> >
> > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> >

Thanks, I've updated that link above to document bug fixing does not require
a filename change.

 Luis
