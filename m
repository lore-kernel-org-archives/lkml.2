Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab0J0PPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:15:42 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:42255 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab0J0PPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:15:40 -0400
Date: Wed, 27 Oct 2010 11:15:28 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
 even if it's a NOOP
Message-ID: <20101027151528.GS10869@flamenco.cs.columbia.edu>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-10-git-send-email-cota@braap.org>
 <4CC804FF.9050908@ge.com>
 <20101027144642.GP10869@flamenco.cs.columbia.edu>
 <4CC83F28.4070802@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC83F28.4070802@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 16:03:04 +0100, Martyn Welch wrote:
> Ok, I'm not going to ack this for now as I'd like to discuss
> modifications to the approach that is being taken for binding devices
> and this patch seems to fall under the scope of this.

No problem, just bear in mind that without this patch, the current
code throws a warning when removing drivers and bridges.

		Emilio

