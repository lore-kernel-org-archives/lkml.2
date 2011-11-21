Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1KUKBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:01:46 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39136
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510Ab1KUKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:01:45 -0500
Date: Mon, 21 Nov 2011 05:01:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Ankit Jain <radical@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/8] readahead: make default readahead size a kernel
 parameter
Message-ID: <20111121100137.GC5084@infradead.org>
References: <20111121091819.394895091@intel.com>
 <20111121093846.251104145@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121093846.251104145@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:18:21PM +0800, Wu Fengguang wrote:
> From: Nikanth Karthikesan <knikanth@suse.de>
> 
> Add new kernel parameter "readahead=", which allows user to override
> the static VM_MAX_READAHEAD=128kb.

Is a boot-time paramter really such a good idea?  I would at least make
it a sysctl so that it's run-time controllable, including beeing able
to set it from initscripts.

