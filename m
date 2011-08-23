Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1HWM47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:56:59 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54719 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1HWM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:56:53 -0400
Date: Tue, 23 Aug 2011 13:56:44 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] dw_apb_timer: constify clocksource name
Message-ID: <20110823125644.GL2796@pulham.picochip.com>
References: <1311608077-4759-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311608077-4759-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 04:34:37PM +0100, Jamie Iles wrote:
> The clocksource name should be const for correctness.
> 
> Cc: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

ping?

Jamie
