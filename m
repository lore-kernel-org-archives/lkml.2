Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0DHFai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:30:38 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56693 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751022Ab0DHFae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:30:34 -0400
Date: Thu, 8 Apr 2010 07:30:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>, Dmitry Torokhov <dtor@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: Re: [PATCH] VMware Balloon driver
Message-ID: <20100408053024.GA1472@ucw.cz>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com> <4BBB622F.4070501@redhat.com> <4BBB7CA3.2060802@goop.org> <4BBB7F1E.3030307@redhat.com> <4BBB890E.5040808@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBB890E.5040808@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> 1) is not a huge amount of code, but something consistent would be  
>>> nice.  2) is something we've been missing and is a bit of an open  
>>> question/research project anyway.
>>
>> 3) Code that attempts to reclaim 2MB pages when possible
>
> Yes.  Ballooning in 4k units is a bit silly.

Does it make sense to treat ballooning as a form of memory hotplug? 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
