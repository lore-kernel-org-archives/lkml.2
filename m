Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1EROeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:34:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:53119 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab1EROes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:34:48 -0400
Date: Wed, 18 May 2011 16:34:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: roccat: fixing actual/startup profile sysfs
 attribute in koneplus
In-Reply-To: <1302707872.2252.3.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1105181634360.28291@pobox.suse.cz>
References: <1302444165.12514.2.camel@neuromancer> <1302707872.2252.3.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, Stefan Achatz wrote:

> startup_profile and actual_profile didn't work as expected. Also
> as the actual profile is persistent, the distinction between the
> two was ambiguous, so both use the same code now and startup_profile
> has been deprecated. Also the event is now propagated through
> chardev. 

Applied.

-- 
Jiri Kosina
SUSE Labs
