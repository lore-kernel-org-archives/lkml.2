Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab1LBQpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:45:39 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33040 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab1LBQpi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 2 Dec 2011 11:45:38 -0500
Message-Id: <4ED90EBF02000078000652BE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Dec 2011 16:45:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Borislav Petkov" <bp@amd64.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com>
 <20111202143517.GA16690@gere.osrc.amd.com>
 <4ED8F46E0200007800065178@nat28.tlf.novell.com>
 <4ED8EB7D.5070802@linux.vnet.ibm.com>
 <20111202152403.GB16690@gere.osrc.amd.com>
 <4ED8FDE102000078000651E5@nat28.tlf.novell.com>
 <4ED8FF7C.2090509@linux.vnet.ibm.com>
In-Reply-To: <4ED8FF7C.2090509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.12.11 at 17:40, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> And if Boris is indeed going to take this patch, Jan, feel free to add
> your "Signed-off-by" (if you agree to the code below) since I would like
> to give due credit to you for pointing out the missing parts.

Feel free to add that or an acked-by.

Jan

