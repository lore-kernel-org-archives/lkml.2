Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2CVTHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:07:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44306 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab2CVTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:07:28 -0400
Message-ID: <1332443286.3858.70.camel@key-ThinkPad-W510>
Subject: Re: [PATCH 00/17] Platform Facilities Option and crypto accelerator
 driver
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 22 Mar 2012 14:08:06 -0500
In-Reply-To: <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032219-7282-0000-0000-000007971CB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> Is there a reason this isn't in drivers/crypto/

  Other arch-specific dirs have their crypto subdir as well such as
arch/s390.  I was just matching that.

Kent

> - k


