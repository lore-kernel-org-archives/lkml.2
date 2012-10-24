Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161514Ab2JXWbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:31:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161317Ab2JXWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:31:04 -0400
Date: Wed, 24 Oct 2012 15:31:00 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC/PATCH 2.6.32.y 0/3] Re: [stable 2.6.32..2.6.34] x86,
 ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()
Message-ID: <20121024223100.GB6922@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
 <20121024182546.GB3338@elie.Belkin>
 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
 <20121024194114.GC3120@elie.Belkin>
 <1351117470.6017.91.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351117470.6017.91.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:

>                               Here is the updated patch with just some
> more text added to the changelog.

Yes, that's clearer.  For what it's worth,
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>

Thanks for your patience.
