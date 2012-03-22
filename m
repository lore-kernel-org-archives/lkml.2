Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030629Ab2CVBuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 21:50:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:39953 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030577Ab2CVBuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 21:50:17 -0400
Message-ID: <1332381004.2982.65.camel@pasglop>
Subject: Re: [PATCH 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 22 Mar 2012 12:50:04 +1100
In-Reply-To: <20120321221517.GB30748@kroah.com>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <1332366068.3858.50.camel@key-ThinkPad-W510>
	 <20120321221517.GB30748@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 15:15 -0700, Greg KH wrote:
> 
> Really?  vio drivers are supposed to look like this with the .name and
> .owner field manually being set in the static initialization of the
> driver?  That's sad, and should be fixed, the vio core should do this
> type of thing for you. 

Yeah, they still do it the old way, nobody got to fix that yet, should
be pretty easy though.

Cheers,
Ben.


