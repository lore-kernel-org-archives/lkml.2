Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0EGXIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:08:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58323 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0EGXIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:08:51 -0400
Message-ID: <4BE49D76.5000001@zytor.com>
Date: Fri, 07 May 2010 16:08:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Ky Srinivasan <ksrinivasan@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Hank Janssen <hjanssen@microsoft.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>
Subject: Re: RFC - Cleaned up hypervisor layer
References: <4BE49778.6060800@zytor.com> <20100507230210.GB24877@kroah.com>
In-Reply-To: <20100507230210.GB24877@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 04:02 PM, Greg KH wrote:
> On Fri, May 07, 2010 at 03:43:04PM -0700, H. Peter Anvin wrote:
>> This patch implements a cleaned up hypervisor layer, plus cleans up some
>> of the aspects of both Hank's MS-HyperV patch and the existing VMware
>> driver.  In particular, the MS-HyperV information is private
>> information, per system, not per CPU, and can thus simply be stored in
>> an ordinary global variable.  This also turns the hypervisor detection
>> into an information structure instead of just an identifier.
> 
> This looks great to me, thanks for doing this work.
> 
> As this is a diff on top of my previous patch, do you want me to merge
> it in with it and resend it, or will you?
> 

I was planning to put this on top of your patch as a second commit, just
to preserve history and authorship.

	-ha
