Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0KDQhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:37:54 -0400
Received: from smtp.nokia.com ([147.243.1.47]:36735 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab0KDQhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:37:52 -0400
Subject: Re: [PATCH] sysfs: device-core: sysfs open close notify
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Greg KH <gregkh@suse.de>
Cc: "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101104160321.GB3631@suse.de>
References: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com>
	 <20101104132339.GC10390@suse.de>
	 <62697B07E9803846BC582181BD6FB6B836EB63CB54@NOK-EUMSG-02.mgdnok.nokia.com>
	 <20101104160321.GB3631@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Thu, 04 Nov 2010 18:37:36 +0200
Message-ID: <1288888656.2072.5.camel@noppispoppis.nmp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 17:03 +0100, ext Greg KH wrote:
> On Thu, Nov 04, 2010 at 02:32:15PM +0100, samu.p.onkalo@nokia.com wrote:
> > It is easy to get rid of if the mode parameter is used to pass the information
> > that this entry uses open_close_notify.  What do you think, is it ok to use
> > mode also to that purpose?
> 
> Don't try to overload a parameter that has been used for the past 40+
> years in one way, to try to add additional side-band data that has
> nothing to do with it.
> 
> That way lies madness.
> 

And that is why I didn't even tried to do that in the first place - even
if it would have been the simple way.

Is the implementation ok otherwise?

I'll add sysfs_create_file_notify which sets the control bit save way.
I think it is enough if these entries can be done attribute by
attribute. It is still possible delete them using normal sysfs
operations.

Thanks for the comments,
Samu


