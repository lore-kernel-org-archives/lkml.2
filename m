Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2BCRhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:37:38 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:40679 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab2BCRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:37:37 -0500
Date: Fri, 3 Feb 2012 15:35:00 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Only probe iTPMs
Message-ID: <20120203173500.GA21715@hardened-box.ibm.com>
References: <20120120175848.310554335@linux.vnet.ibm.com>
 <20120120175930.702036458@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120175930.702036458@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020317-1524-0000-0000-00000156113A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012, Stefan Berger wrote:

> Detect iTPMs through the vendor ID on the hardware interface and only
> probe the device if the manufacturer is found to be Intel. This
> obsoletes a previously added delay necessary for some TPMs but not iTPMs. 
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
>

Applied to github.com:srajiv/tpm.git next

Thanks,
Rajiv

