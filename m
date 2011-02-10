Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1BJS7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:59:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1BJS7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:59:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos before entering idle
Date: Thu, 10 Feb 2011 19:59:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Tim Chen <tim.c.chen@linux.intel.com>, mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
References: <1297300864.2645.128.camel@schen9-DESK> <20110210034656.GA22753@gargoyle.amr.corp.intel.com>
In-Reply-To: <20110210034656.GA22753@gargoyle.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101959.02733.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 10, 2011, Andi Kleen wrote:
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Patch looks good to me. Thanks Tim.

I'm taking that as an ACK.

Thanks,
Rafael
