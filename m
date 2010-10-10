Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0JJRCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab0JJRCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:02:03 -0400
Date: Sun, 10 Oct 2010 18:01:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010170151.GD28828@agk-dp.fab.redhat.com>
Mail-Followup-To: Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <ak@linux.intel.com>,
	device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
	linux-kernel@vger.kernel.org
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010162257.GA1272@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 12:22:57PM -0400, Mike Snitzer wrote:
> this out quite yet.  You have 4 patches yet you say conceptually there
> are 2 distinct changes.
 
IOW should we end up with 2 bisectable patches here?

And the potentially-broken/poorly-performing stacked async should be
explained in comments inline perhaps if we're choosing to ignore this
apparent regression.

Alasdair

