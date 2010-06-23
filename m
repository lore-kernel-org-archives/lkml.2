Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab0FWGXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:23:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62568 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0FWGXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tPUUmEQW65aFBv5DGnsjF8tqi/v+dpF3h6fbhHJmJtOIdaR+M+Plkh+yyjf+5wzblg
         KIisKgGXWGfZr5OPpEbx7HAiN+TBeDZNNJRMIszzhTJ54BoO+EGn25LnBs7Rf6fwumwA
         647sJEfZ8jlfi3knCiDY71EiHIICMH5yZU6UA=
Date: Tue, 22 Jun 2010 23:23:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Todd Fischer <todd.fischer@ridgerun.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] INPUT: tps6507x-ts, remove unneeded NULL test
Message-ID: <20100623062341.GA8963@core.coreip.homeip.net>
References: <1277206862-27146-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277206862-27146-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 01:41:02PM +0200, Jiri Slaby wrote:
> Stanse found that tsc is dereferenced earlier than checked for being
> NULL in tps6507x_ts_remove. Remove the test because I see no way, how
> tsc can be NULL there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Todd Fischer <todd.fischer@ridgerun.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-input@vger.kernel.org

Applied, thanks Jiri.

-- 
Dmitry
