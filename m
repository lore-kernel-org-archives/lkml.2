Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1LBUAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:00:20 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40138 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1LBUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:00:18 -0500
Message-ID: <4ED92E47.1010500@linux.vnet.ibm.com>
Date: Sat, 03 Dec 2011 01:30:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com> <20111202143517.GA16690@gere.osrc.amd.com> <4ED8F46E0200007800065178@nat28.tlf.novell.com> <4ED8EB7D.5070802@linux.vnet.ibm.com> <20111202152403.GB16690@gere.osrc.amd.com> <4ED8FDE102000078000651E5@nat28.tlf.novell.com> <4ED8FF7C.2090509@linux.vnet.ibm.com> <4ED90EBF02000078000652BE@nat28.tlf.novell.com> <4ED901F5.3080302@linux.vnet.ibm.com> <20111202194518.GE15204@aftab>
In-Reply-To: <20111202194518.GE15204@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120209-7014-0000-0000-00000032B596
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 01:15 AM, Borislav Petkov wrote:

> On Fri, Dec 02, 2011 at 10:21:01PM +0530, Srivatsa S. Bhat wrote:
>> Wow! Good to know that we have an agreement :-)
>> Boris, it is again up to you to choose among the two(Signed-off-by or Acked-by)
>> for Jan. Hehe ;-)
> 
> Well,
> 
> since Ingo hasn't pulled yet, I merged the two patches after adding the
> required S-O-Bs into the following:
> 


Great! Thank you.

Regards,
Srivatsa S. Bhat

