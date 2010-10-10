Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0JJSsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 14:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0JJSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 14:48:44 -0400
Date: Sun, 10 Oct 2010 19:48:27 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Milan Broz <mbroz@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010184827.GG28828@agk-dp.fab.redhat.com>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Milan Broz <mbroz@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <ak@linux.intel.com>,
	device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
	linux-kernel@vger.kernel.org
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <20101010170151.GD28828@agk-dp.fab.redhat.com> <20101010174454.GA21681@basil.fritz.box> <20101010181736.GE28828@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010181736.GE28828@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 07:17:36PM +0100, Alasdair G Kergon wrote:
> AFAIK Nested dm-crypt is not extreme for some folk who have routine
> configurations using it.  But if in_interrupt is set how does this code
> work for them now compared to how it worked before?
 
And indeed, even if in_interrupt is not set, is there any performance
impact for this (minority) class of users?

Alasdair

