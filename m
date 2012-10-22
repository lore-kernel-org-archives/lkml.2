Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2JVPek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:34:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2JVPei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:34:38 -0400
Message-ID: <50856760.2030507@redhat.com>
Date: Mon, 22 Oct 2012 11:33:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com,
        avi@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH RFC V2 0/5] Separate consigned (expected steal) from steal
 time.
References: <20121017022249.16949.2775.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 10:23 PM, Michael Wolf wrote:
> In the case of where you have a system that is running in a
> capped or overcommitted environment the user may see steal time
> being reported in accounting tools such as top or vmstat.  This can
> cause confusion for the end user.

How do s390 and Power systems deal with reporting that kind
of information?

IMHO it would be good to see what those do, so we do not end
up re-inventing the wheel, and confusing admins with yet another
way of reporting the information...

-- 
All rights reversed
