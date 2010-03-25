Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0CYX0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:26:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53005 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901Ab0CYX0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:26:42 -0400
Date: Thu, 25 Mar 2010 23:30:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH] serial: TTY: new ldiscs for staging
Message-ID: <20100325233030.57ae6544@lxorguk.ukuu.org.uk>
In-Reply-To: <1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 18:20:16 -0500
pavan_savoy@ti.com wrote:

> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Push the max ldiscs by a few number to allow ldiscs
> to exist in the staging directory
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>

Acked-by: Alan Cox <alan@linux.intel.com>
