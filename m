Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab0JHVnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:43:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:10368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab0JHVnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:43:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,305,1283756400"; 
   d="scan'208";a="333931323"
Message-ID: <4CAF9096.20408@intel.com>
Date: Fri, 08 Oct 2010 14:43:50 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
References: <20101008213429.GB7223@sgi.com>
In-Reply-To: <20101008213429.GB7223@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 02:34 PM, Russ Anderson wrote:
> 	[BUG] x86: bootmem broken on SGI UV
> 
> Recent community kernels do not boot on SGI UV x86 hardware with
> more than one socket.  I suspect the problem is due to recent 
> bootmem/e820 changes.
> 

You may want to try the tip master kernel, which has a bunch of changes
in that area.

Unfortunately, I think you can probably understand that UV-specific
debugging is out of reach for most people outside SGI.

	-hpa
