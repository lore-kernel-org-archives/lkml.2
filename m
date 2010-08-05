Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab0HECXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:23:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:49679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633Ab0HECXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:23:11 -0400
Subject: Re: [PATCH] powerpc: Add vmcoreinfo symbols to allow makdumpfile
 to filter core files properly
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
        hbabu@us.ibm.com, paulus@samba.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20100804144929.GA13970@hmsreliant.think-freely.org>
References: <20100713134609.GA14514@hmsreliant.think-freely.org>
	 <20100804144929.GA13970@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 12:04:26 +1000
Message-ID: <1280973866.1902.168.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:49 -0400, Neil Horman wrote:
> Ping yet again. Ben, This needs review/acceptance from you or Paul
> Neil 

Isn't it already in powerpc-next about to be pulled by Linus ?

In general, I recommend you check the status of your patches on
patchwork. I'm nagging Jeremy to add a feature so it emails the
submitter when the patch status changes :-)

Cheers,
Ben.

