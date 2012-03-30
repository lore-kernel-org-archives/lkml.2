Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311Ab2C3TIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:08:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54719 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756818Ab2C3TIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:08:52 -0400
Message-ID: <1333134530.27601.2.camel@joe2Laptop>
Subject: Re: [linux-pm] [PATCH 17/76] thermal_sys: convert printks to
 pr_<level>
From: Joe Perches <joe@perches.com>
To: eduardo.valentin@ti.com
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2012 12:08:50 -0700
In-Reply-To: <20120330134119.GA13130@besouro>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	 <c5a01dd52dc4903772f464ea580895ccc36e911d.1333101989.git.len.brown@intel.com>
	 <20120330134119.GA13130@besouro>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 16:41 +0300, Eduardo Valentin wrote:
> On Fri, Mar 30, 2012 at 06:13:20AM -0400, Len Brown wrote:
> > From: Joe Perches <joe@perches.com>
> > Use the current logging style.
[]
> We should get the struct dev in thermal_zone_device, I think it makes
> more sense to use the dev_* helper functions.
[]
> The orig argument could probably be changed to a thermal zone device
> and the we use it's id as orig for the message.
> What do you think?

dev_<level> should be used instead of pr_<level> when
an appropriate struct device * is available.

cheers, Joe

