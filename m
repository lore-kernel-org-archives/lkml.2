Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab2JKNSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:18:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45040 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab2JKNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:18:06 -0400
Date: Thu, 11 Oct 2012 14:18:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?Trep=E1k?= Vilmos <trepo@netcomga.sk>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: hp-wmi: add rfkill support for integrated GPS
Message-ID: <20121011131804.GA7266@srcf.ucam.org>
References: <1349952660.1577.43.camel@pluto.netcomga.sk>
 <20121011123415.GA6056@srcf.ucam.org>
 <1349961347.29045.8.camel@pluto.netcomga.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349961347.29045.8.camel@pluto.netcomga.sk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 03:15:47PM +0200, Trepák Vilmos wrote:
> On Thu, 2012-10-11 at 13:34 +0100, Matthew Garrett wrote:
> > I don't think this bit is right - in this codepath, wireless is a mask, 
> > so 0x3 would mean wifi and bluetooth, not gps. I'd expect gps to be 0x8.
> 
> And you'd expect right. Re-tested with 0x8, it works.

Ok.

> >  
> > The rest looks good, though.
> > 
> 
> Of course it does, it's just copy & paste & replace... I don't even
> think I deserve credit for it.
> 
> Is it worth it to resubmit the patch for a 1-byte change or will you
> just take care of it yourself? If it's easier for you, I'll resubmit.

No worries, I'll fix it up. Thanks!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
