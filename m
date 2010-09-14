Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0INOaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:30:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:48905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0INOaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:30:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,365,1280732400"; 
   d="scan'208";a="606787492"
Date: Tue, 14 Sep 2010 14:45:28 +0100
From: Alan Cox <alan@linux.intel.com>
To: dave@gnu.org
Cc: jianwei.yang@intel.com, gregkh@suse.de, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: max3107: Fix memory leaks when returning on
 error
Message-ID: <20100914144528.77ee7a6f@linux.intel.com>
In-Reply-To: <1284394091.2055.5.camel@cowboy>
References: <1284394091.2055.5.camel@cowboy>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 12:08:11 -0400
Davidlohr Bueso <dave@gnu.org> wrote:

> [PATCH] serial: max3107: Fix memory leaks in max3107_probe() when
> returning on error.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Acked-by: Alan Cox <alan@linux.intel.com>
