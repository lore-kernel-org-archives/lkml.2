Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab0CRVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:50:27 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:49644 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab0CRVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:50:25 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF49okurR7Hu/2dsb2JhbACbLHOjdpkBhHkEgx0
X-IronPort-AV: E=Sophos;i="4.51,269,1267401600"; 
   d="scan'208";a="168649066"
From: Roland Dreier <rdreier@cisco.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
References: <20100316204845.GJ8278@ldl.fc.hp.com>
	<20100309184723.GA31374@kroah.com> <20100316212445.GA15729@xanatos>
	<20100316214014.GA8839@kroah.com> <20100318213308.GA5461@xanatos>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 18 Mar 2010 14:50:21 -0700
In-Reply-To: <20100318213308.GA5461@xanatos> (Sarah Sharp's message of "Thu,
	18 Mar 2010 14:33:08 -0700")
Message-ID: <ada634t710i.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > "On" or "off" doesn't really help when you're trying to debug different
 > parts of the driver.  If you're trying to debug a command, messages
 > about wrapping rings or enqueueing transfers doesn't really matter.

For this debugging stuff, you could look at using the trace events
infrastructure, which gives very fine control over what output is
enabled and overall is pretty awesome.  You can look in
include/trace/events for examples, eg look at
include/trace/events/ext4.h and then look in fs/ext4 to see where
trace_ext4_xxx() functions get called.

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
