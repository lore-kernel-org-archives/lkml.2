Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab2CZQJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:09:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46372 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab2CZQJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:09:51 -0400
Message-ID: <1332778237.6578.3.camel@key-ThinkPad-W510>
Subject: Re: [PATCH 00/17] Platform Facilities Option and crypto accelerator
 driver
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 26 Mar 2012 11:10:37 -0500
In-Reply-To: <06B7F1E7-951D-4753-BE00-7B0C84BACDAE@kernel.crashing.org>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
	 <1332443286.3858.70.camel@key-ThinkPad-W510>
	 <06B7F1E7-951D-4753-BE00-7B0C84BACDAE@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032616-7182-0000-0000-0000011E13B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> From what I can tell this isn't ISA level instructions and thus should NOT be in arch/powerpc.  This should be moved into drivers/crypto

  That makes sense.  I'll move them over in my next submission.

Kent

> - k


