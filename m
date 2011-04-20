Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1DTSHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:07:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:42873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1DTSHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:07:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,247,1301900400"; 
   d="scan'208";a="681628468"
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Rientjes <rientjes@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <20110420104654.6b457142@lxorguk.ukuu.org.uk>
References: <james_p_freyensee@linux.intel.com>
	 <1303253889-10074-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.DEB.2.00.1104191822440.8047@chino.kir.corp.google.com>
	 <20110420104654.6b457142@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 20 Apr 2011 11:07:18 -0700
Message-ID: <1303322838.13457.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 10:46 +0100, Alan Cox wrote:
> > is small enough that it shouldn't be an issue.  Otherwise there's nothing 
> > protecting sizeof(current->comm) from changing without holding 
> > task_lock(current).
> 
> The C language definition for one - sizeof() is a constant at compile time

K, thanks, I'll look at re-working these couple lines of code.


