Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2LMA0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:26:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab2LMA0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:26:50 -0500
Date: Wed, 12 Dec 2012 19:26:46 -0500
From: Dave Jones <davej@redhat.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: Re: Thermal: Add a thermal notifier for user space
Message-ID: <20121213002646.GA28642@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>
References: <20121212180547.F12BE6606F0@gitolite.kernel.org>
 <20121212182838.GA7497@redhat.com>
 <1355358199.2276.2.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355358199.2276.2.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 08:23:19AM +0800, Zhang Rui wrote:
 
 > > 
 > > This is terribly generic sounding.  Might I suggest THERMAL_USER_SPACE instead ?
 > > 
 > Hi, Dave,
 > 
 > You're right. How about the patch attached?

Looks good to me,

thanks,

	Dave

