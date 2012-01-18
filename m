Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2ARVt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:49:26 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:41202 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2ARVtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:49:25 -0500
Message-ID: <1326923285.9412.21.camel@x61.thuisdomein>
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Jones <drjones@redhat.com>, rientjes@google.com, mingo@elte.hu,
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
Date: Wed, 18 Jan 2012 22:48:05 +0100
In-Reply-To: <20120118122830.037f1e29.akpm@linux-foundation.org>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
	 <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
	 <20120118122830.037f1e29.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 12:28 -0800, Andrew Morton wrote:
> I can see an argument for retaining EXPERIMENTAL: as a way of telling
> people that the particular feature might not yet be ready for prime
> time.

The kernel configuration used for the kernels currently shipped with
Fedora 16 and Debian 6.0.3 (ie, stable or squeeze), which are the
configurations I can examine here, have CONFIG_EXPERIMENTAL set. Perhaps
Debian and Fedora need that option for a few odd features. But it seems
that the message given by having a feature depend on EXPERIMENTAL - to
people using those configurations as a base to fine tune the kernel to
their needs - isn't so strong.

Are there any mainstream distributions that do not enable EXPERIMENTAL?


Paul Bolle

