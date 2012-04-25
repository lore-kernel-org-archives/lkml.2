Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2DYKYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:24:06 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39251 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2DYKYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:24:04 -0400
Date: Wed, 25 Apr 2012 12:23:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Frank Arnold <frank.arnold@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL] L3 CID fix for 3.5
Message-ID: <20120425102357.GC20853@gmail.com>
References: <20120419070053.GB16645@elgon.mountain>
 <4F8FCA3A.5060504@linux.vnet.ibm.com>
 <20120419110229.GB30447@aftab>
 <20120419114453.GO6498@mwanda>
 <20120419165353.GF3221@aftab.osrc.amd.com>
 <20120425093001.GA18882@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425093001.GA18882@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Ping?
> 
> Guys, any issues with this that I should know of?

Looks good to me. You marked it v3.5, should I pull it into 
v3.4? Looks small enough to me and we better keep such user 
facing interfaces correct, even if there's no direct regression.

Thanks,

	Ingo
