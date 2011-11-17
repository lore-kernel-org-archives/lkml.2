Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1KQTrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:47:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab1KQTrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:47:48 -0500
Date: Thu, 17 Nov 2011 14:47:20 -0500
From: Dave Jones <davej@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111117194719.GA23213@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
	Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
	linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110093442.GG3153@redhat.com>
 <20111114184717.GA7006@redhat.com>
 <20111115101313.GA28350@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115101313.GA28350@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 10:13:13AM +0000, Mel Gorman wrote:
 
 > If they are still experiencing major stalls, I have an experimental
 > script that may be able to capture stack traces of processes stalled
 > for more than 1 second. I've had some success with it locally so
 > maybe they could try it out to identify if it's THP or something else.
 
I'm not sure if it's the same problem, but I'd be interested in trying
that script.

When I build a kernel on my laptop, when it gets to the final link stage,
and there's a ton of IO, my entire X session wedges for a few seconds.
This may be unrelated, because this is on an SSD, which shouldn't suffer
from the slow IO of the USB devices mentioned in this thread.

(This is even with that patch applied btw, perhaps adding further fuel to
the idea that it's unrelated).

	Dave

