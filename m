Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab1FAVtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:49:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:31930 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1FAVtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,305,1304319600"; 
   d="scan'208";a="10556201"
Date: Wed, 1 Jun 2011 22:36:19 +0100
From: Alan Cox <alan@linux.intel.com>
To: Andre Bartke <andre.bartke@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: Re: [PATCH] staging/gma500: Fix uninitialized variable and style
 issues
Message-ID: <20110601223619.077c3462@bob.linux.org.uk>
In-Reply-To: <1306960495-9844-1-git-send-email-andre.bartke@gmail.com>
References: <1306960495-9844-1-git-send-email-andre.bartke@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jun 2011 22:34:55 +0200
Andre Bartke <andre.bartke@googlemail.com> wrote:

> The return variable of psb_gtt_pin() may be used
> uninitialized. Also fixed some coding style issues.
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>

Applied by hand (some other changes in the tree)

Thanks - the pin bug could have been quite nasty to chase down.

