Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0JRLsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:48:13 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35650 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0JRLsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:48:12 -0400
Subject: Re: Discard benchmarking tool for SSD's and thinly provisioned
 devices
From: Peter Zijlstra <peterz@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1010181336130.6517@dhcp-lab-213.englab.brq.redhat.com>
References: <alpine.LFD.2.00.1010181247330.6517@dhcp-lab-213.englab.brq.redhat.com>
	 <alpine.LFD.2.00.1010181336130.6517@dhcp-lab-213.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 13:47:54 +0200
Message-ID: <1287402474.29097.1551.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 13:40 +0200, Lukas Czerner wrote:
> 
> Also note that there might be some devices with buggy firmware which may
> be damaged beyond repair by the TRIM command, especially with TRIM
> performed in random IO pattern (from first-hand experience). 

A list of known bad devices might be appreciated..
