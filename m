Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2BTJnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:43:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:55678 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2BTJnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:43:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of matt.fleming@intel.com designates 10.180.83.97 as permitted sender) smtp.mail=matt.fleming@intel.com
Subject: Re: build failure in Linus' tree with gcc 4.4.3
From: Matt Fleming <matt.fleming@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
	 <20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 20 Feb 2012 09:43:39 +0000
Message-ID: <1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 14:22 +1100, Stephen Rothwell wrote:
> Which is all endian specific code that will run on the host when building
> the kernel ...

Gah, right. I didn't think about cross-building this code.

Thanks Stephen, I'll fix this up.



