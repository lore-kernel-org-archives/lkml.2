Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2J3IDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:03:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37411 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2J3IDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:03:42 -0400
Date: Tue, 30 Oct 2012 09:03:19 +0100
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Nouveau regression between 3.6 and 3.7-rc3: driver stuck at
 "running init tables"
Message-ID: <20121030080319.GA31945@kashmir>
Mail-Followup-To: Mathieu Chouquet-Stringer <mathieu@csetco.com>,
	Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20121029230647.GA10369@kashmir>
 <1351552559.3810.2.camel@turiel>
 <20121029233237.GA10839@kashmir>
 <1351573979.3810.4.camel@turiel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351573979.3810.4.camel@turiel>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
 3:{EoxBR
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 03:12:59PM +1000, Ben Skeggs wrote:
> Not sure what's up with the hang yet, however, I noticed the issue [1]
> which is likely causing the error messages from nouveau's i2c code.
> With some luck, it'll stop triggering whatever bug is making it hang in
> the VBIOS init table parser.

Just tested that and it works (TM).  So yeah, that fixed it.  Thanks.

Reported-by: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Tested-by: Mathieu Chouquet-Stringer <mathieu@csetco.com>

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
