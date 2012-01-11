Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab2AKVEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:04:30 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:43572 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2AKVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:04:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20237.63802.982209.699996@quad.stoffel.home>
Date: Wed, 11 Jan 2012 16:03:54 -0500
From: "John Stoffel" <john@stoffel.org>
To: Christoph Lameter <cl@linux.com>
Cc: John Stoffel <john@stoffel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
In-Reply-To: <alpine.DEB.2.00.1201111305440.31239@router.home>
References: <20120109181023.7c81d0be@annuminas.surriel.com>
	<4F0B7D1F.7040802@gmail.com>
	<4F0BABE0.8080107@redhat.com>
	<CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com>
	<CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
	<20237.39051.575883.450826@quad.stoffel.home>
	<alpine.DEB.2.00.1201111305440.31239@router.home>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Lameter <cl@linux.com> writes:

Christoph> On Wed, 11 Jan 2012, John Stoffel wrote:
KOSAKI> so, we can eat free lunch up to 7MB ~= 60(MB/sec) * 1000 / 8.5(ms).
>> 
>> What if the disk is busy doing other writeout or readin during this
>> time?  You can't assume you have the full disk bandwidth available,
>> esp when you hit a swap storm like this.

Christoph> The assumptions by Kosaki are quite conservative.

Just checking

Christoph> What if one did not get a disk from the garbage heap but
Christoph> instead has a state of the art storage cluster or simply an
Christoph> SSD (in particular relevant now since HDs are in short
Christoph> supply given the situation in Asia)?

I don't know, I was just trying to make sure he thinks about disks
which are slower than he expects, since there are lots of them still
out there.  

John

