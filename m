Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab1EMRMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:12:05 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:61963 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab1EMRMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:12:03 -0400
Date: Fri, 13 May 2011 19:11:48 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] export bus_kset
Message-ID: <20110513171148.GM29259@mail.gnudd.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <1305220265-9020-2-git-send-email-lamiaposta71@gmail.com> <201105122128.54172.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201105122128.54172.rjw@sisk.pl>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:28:53PM +0200, Rafael J. Wysocki wrote:

hi,

sorry, I missed this message this morning.

> On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> Please explain why you need to export it, what the alternatives are and
> why you think this approach is better than the alternatives.
> 

what I needed to do was walking through the list of registered busses,
and invoking the bus_added()/bus_removed() callback of a newly registered
policy. I couldn't find any other simple way to do it.

Regards
Davide
