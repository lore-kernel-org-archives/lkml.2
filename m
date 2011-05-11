Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1EKR0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:26:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:16778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab1EKRZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:25:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="434422792"
Subject: Re: [PATCH] dmaengine: at_hdmac: pause: no need to wait for FIFO
 empty
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DC929EC.6040706@atmel.com>
References: <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com>
	 <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com>
	 <4DC927DF.1060808@ru.mvista.com>  <4DC929EC.6040706@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 22:23:20 +0530
Message-ID: <1305132800.28926.53.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 14:05 +0200, Nicolas Ferre wrote:
> Le 10/05/2011 13:56, Sergei Shtylyov :
> > Hello.
> > 
> > On 09-05-2011 20:11, Nicolas Ferre wrote:
> > 
> >> The addition of the pause feature to atc_control an active wait was
> >> introduced
> >> to check the FIFO empty event.
> > 
> >    Couldn't parse this -- did you forget "with"at the start of the
> > statement?
> 
> Absolutely. A comma can also improve things... is it better like this?
> 
> "
> With the addition of the "pause" feature, an active wait loop was
> introduced to check the "FIFO empty" event.
> "
> 
> Vinod, tell me if you want me to send a new patch.
Its okay, I can fix the commit


-- 
~Vinod

