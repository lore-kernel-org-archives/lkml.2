Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1HPA5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:57:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:35342 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HPA5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:57:39 -0400
Date: Tue, 16 Aug 2011 10:57:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
In-Reply-To: <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.LRH.2.00.1108161056310.7706@tundra.namei.org>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:

> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> 
> Adds the multi-precision-integer maths library which was originally taken
> from GnuPG and ported to the kernel by (among others) David Howells.
> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.

First thing -- this code needs to be formatted using kernel coding style.


- James
-- 
James Morris
<jmorris@namei.org>
