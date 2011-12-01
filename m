Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1LANbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:31:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1LANbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:31:04 -0500
Date: Thu, 1 Dec 2011 14:31:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201133116.GD5706@redhat.com>
References: <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
 <20111201105538.GA4504@tiehlicka.suse.cz>
 <20111201115911.GA5706@redhat.com>
 <20111201124440.GB25614@tiehlicka.suse.cz>
 <20111201125554.GC5706@redhat.com>
 <CAB3XZEeNF8_U__rOPMfiOFNjPTS6gb33CSjdwkhMdRmS+i3CTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB3XZEeNF8_U__rOPMfiOFNjPTS6gb33CSjdwkhMdRmS+i3CTw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 03:13:42PM +0200, Eliad Peller wrote:
> i don't really care about temporarily reverting it.
> but maybe you can just add an "initialized" flag to iwl3945_rs_sta,
> and check it on free_sta?

This is not right solution, that will prevent hangs though, but
we generally wipe out used data, so any other problem could be
triggered.

Stanislaw 
