Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1A1Mvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:51:50 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:45290 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751393Ab1A1Mvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:51:49 -0500
Subject: Re: [PATCH 2/2] USB: tools: Add a Makefile
From: Davidlohr Bueso <dave@gnu.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <4D42B8B4.40404@ru.mvista.com>
References: <1296157174.2113.6.camel@offworld>
	 <4D42B436.8070901@ru.mvista.com> <1296217427.2169.0.camel@offworld>
	 <4D42B8B4.40404@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 09:51:37 -0300
Message-ID: <1296219097.2169.6.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 15:38 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 28-01-2011 15:23, Davidlohr Bueso wrote:
> 
> >> On 27-01-2011 22:39, Davidlohr Bueso wrote:
> 
> >>> I originally sent this in several months ago, but never got around to correcting the changes, so... here it is.
> 
> >>      This remark should follow the --- tear line, to be automatically stripped
> >> when applying the patch.
> 
> > It wasn't meant for the log, that's why it's above the tear line.
> 
>     Everything above the tearline gets into the changelog. If it wasn't meant 
> to, it should be below the tearline, or have to be manually edited out of it.
> 
I should have been clearer. What I meant was that the text I didn't want
in the changelog was above the "From:" (and of course above the ---). I
didn't know it is supposed to be below the tearline. Thanks for pointing
this out. 
If anyone is going to take the patch, do you prefer for me to resend it?


Thanks.

