Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1BJTcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:32:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:45597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1BJTce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:32:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="601434600"
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
From: Tim Chen <tim.c.chen@linux.intel.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1297359914.4933.56.camel@mulgrave.site>
References: <1297300864.2645.128.camel@schen9-DESK>
	 <1297359914.4933.56.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 11:33:04 -0800
Message-ID: <1297366384.2645.175.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 11:45 -0600, James Bottomley wrote:

> 
> What you say is true as long as the value is 32 bits ... perhaps a note
> of that should be made somewhere?
> 

It seems like pm_qos_add_request, pm_qos_update_request only uses 32
bits value.  Did I miss some cases where the target value for
pm_qos_object be non-32 bit under some situation?

Tim

