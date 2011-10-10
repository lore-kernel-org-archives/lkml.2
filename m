Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1JJHMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:12:18 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:53823 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1JJHMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:12:17 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: penberg@cs.helsinki.fi
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Date: Mon, 10 Oct 2011 18:12:15 +1100
In-Reply-To: <6127211897.1002662375@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl>
	 <201110062045.48689.rjw@sisk.pl>
	 <CAOJsxLE7uRFv6FXsz+czLO3+VjDtT-QgHVRZEpZwBJJF0B3ahw@mail.gmail.com>
	 <6127211897.1002662375@rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318230735.2019.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-09 at 21:19 +1100, Bojan Smojver wrote:
> I kinda remember reading in one of the bug reports for Intel graphics
> about someone doing it. Not sure how, to be honest.

This worked for me on Fedora:

echo -n reboot > /sys/power/disk
for (( i=0; i<5; i++)); do pm-hibernate; sleep 2; done

PS. Obviously, substitute pm-hibernate for whatever you distro uses.

-- 
Bojan

