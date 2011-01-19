Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1ASOcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:32:21 -0500
Received: from thunk.org ([69.25.196.29]:38704 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab1ASOcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:32:20 -0500
Date: Wed, 19 Jan 2011 09:32:14 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: czoccolo@gmail.com, vgoyal@redhat.com, jaxboe@fusionio.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110119143214.GA3043@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, "Alex,Shi" <alex.shi@intel.com>,
	czoccolo@gmail.com, vgoyal@redhat.com, jaxboe@fusionio.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>
References: <1295402148.4773.143.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295402148.4773.143.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:55:48AM +0800, Alex,Shi wrote:
> Shaohua and I tested kernel building performance on latest kernel. and
> found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> system. 

What kerenl version were you comparing against?  And what were you
using to benchmark this performance drop?  I'm curious what your
workload was; I'm guesisng it was some kind of mixed read/write
workload?  Were there any fsync()'s involved?

Thanks, regards,

						- Ted
