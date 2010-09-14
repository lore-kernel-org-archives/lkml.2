Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0INSH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:07:58 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:14290 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab0INSH5 (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:2>);
	Tue, 14 Sep 2010 14:07:57 -0400
Message-Id: <4C90469402000023000205B8@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 14 Sep 2010 12:07:48 -0600
From: "Joey Lee" <jlee@novell.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: <randy.dunlap@oracle.com>, <mjg@redhat.com>, <mjg59@srcf.ucam.org>,
        <gregkh@suse.de>, <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add Intel Poulsbo Stub Driver
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis, 

Thank's for your kindly review.

於 二，2010-09-14 於 13:10 -0400，Valdis.Kletnieks@vt.edu 提到：
> On Tue, 14 Sep 2010 10:39:42 +0800, "Lee, Chun-Yi" said:
> > 
> > +        select ACPI_VIDEO if ACPI
> > +	help
> > +	  Choose this option if you have a system that has Intel Poulsbo
> > +	  integrated graphics.
> 
> Can we have a part number or something here?  When I buy a system from Dell or
> someplace, the spec sheet doesn't say 'Poulsbo', it says 'i945' or 'i987' or
> something like that.
> 
> (If this is a not-yet-escaped-from-engineering new part, maybe a follow-up patch
> when the part is officially named/announced?)
> 

I just google the MSI U110/U115 poulsbo netbook on my hand, it's a Intel
Menlow netbook.
I am not sure _Menlow_ is a more popular name compare with _Poulsbo_,
how do you think about that?
Should I put the _Menlow_ in config help ?


Thank's a lot!
Joey Lee

