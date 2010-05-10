Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0EJPX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:23:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41810 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0EJPXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:23:54 -0400
Message-ID: <4BE824F0.3030301@zytor.com>
Date: Mon, 10 May 2010 08:23:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "hjanssen@microsoft.com" <hjanssen@microsoft.com>,
       "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper
 API
References: <4BE49778.6060800@zytor.com> <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org> <4BE6705C.3000206@zytor.com> <201005100106.07156.dtor@vmware.com>
In-Reply-To: <201005100106.07156.dtor@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 01:06 AM, Dmitry Torokhov wrote:
> 
> Source please? I was not aware that there was a standard governing
> returns code for module init methods.
> 

ENODEV means "not a device node."
ENXIO means "hardware not present."

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

