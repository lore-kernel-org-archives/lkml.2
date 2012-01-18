Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2ARWG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:06:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2ARWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:06:25 -0500
Date: Thu, 19 Jan 2012 01:06:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Jones <drjones@redhat.com>, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, arnd@arndb.de,
        holt@sgi.com, linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com,
        jesper nilsson <jesper.nilsson@axis.com>, dhowells@redhat.com,
        takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120118220616.GA5351@p183.telecom.by>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
 <20120118122830.037f1e29.akpm@linux-foundation.org>
 <1326923285.9412.21.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326923285.9412.21.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 10:48:05PM +0100, Paul Bolle wrote:
> Are there any mainstream distributions that do not enable EXPERIMENTAL?

I don't think so.

Regardless, CONFIG_EXPERIMENTAL should be ignored when deciding
whether to enable feature or not.
