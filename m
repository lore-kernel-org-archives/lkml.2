Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384Ab2J2XdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:33:01 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33049 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761327Ab2J2XdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:33:00 -0400
Date: Tue, 30 Oct 2012 00:32:37 +0100
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Nouveau regression between 3.6 and 3.7-rc3: driver stuck at
 "running init tables"
Message-ID: <20121029233237.GA10839@kashmir>
Mail-Followup-To: Mathieu Chouquet-Stringer <mathieu@csetco.com>,
	Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20121029230647.GA10369@kashmir>
 <1351552559.3810.2.camel@turiel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351552559.3810.2.camel@turiel>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
 3:{EoxBR
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi again,

On Tue, Oct 30, 2012 at 09:15:59AM +1000, Ben Skeggs wrote:
> Are you able to go back to the current master, and get me a
> log/screenshot with "nouveau.debug=trace" appended to your kernel
> options?

Hmmm I did just that on v3.7-rc3-8-g35fd3dc and it doesn't seem to
output more stuff:

http://mathieu.csetco.com/nouveau.jpeg
-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
