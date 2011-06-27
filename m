Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1F0Tq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:46:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62399 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1F0Tpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QrEGCuTG0TbMFLiKttzeNYwXN3MK2UOA6k3z71jdvaoTteQyLdy/mduSYqtuJuD+HB
         hLYlDDYETL8+89Eb41qzQ6csELdLRT2mWnsavTsXAcjUY518htCuz27+kvEO1REff6f7
         +Q3cC5k/SkqPuxAIBtzd0K0vracJKtORA/k88=
Date: Mon, 27 Jun 2011 12:45:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: tnetv107x-keypad - fix MODULE_ALIAS
Message-ID: <20110627194507.GC13829@core.coreip.homeip.net>
References: <1309185168.29085.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309185168.29085.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 10:32:48PM +0800, Axel Lin wrote:
> Remove the space between "platform:" prefix and the driver name.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied both, thanks Axel.

-- 
Dmitry
