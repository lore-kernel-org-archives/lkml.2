Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2DCN4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:56:37 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9326 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2DCN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:56:36 -0400
Date: Tue, 3 Apr 2012 08:56:34 -0500
From: scameron@beardog.cce.hp.com
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, mike.miller@hp.com,
        iss_storagedev@hp.com
Subject: Re: [PATCH] cciss: use check_signature
Message-ID: <20120403135634.GP32669@beardog.cce.hp.com>
References: <20120403134554.GO32669@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403134554.GO32669@beardog.cce.hp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 08:45:54AM -0500, scameron@beardog.cce.hp.com wrote:
> > Use check_signature to find a signature in the mmio address.

Also, drivers/scsi/hpsa.c has similar code, the function
hpsa_CISS_signature_present could be replaced by
a call to check_signature, if you feel like making
such a patch.  (If not, I can do it.)

-- steve

