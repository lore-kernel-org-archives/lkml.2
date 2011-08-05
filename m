Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1HERCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:02:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35385 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1HERCy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com:7:1>);
	Fri, 5 Aug 2011 13:02:54 -0400
Message-Id: <4E3C304B02000078000740C8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 05 Aug 2011 18:02:50 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <matt@console-pimps.org>, <johnstul@us.ibm.com>
Cc: <fenghua.yu@intel.com>, <tony.luck@intel.com>, <hpa@linux.intel.com>,
        <mjg@redhat.com>, <a.zummo@towertech.it>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Matt Fleming  08/04/11 5:37 PM >>>
>On Thu, 2011-08-04 at 03:22 -0700, john stultz wrote:
>> Sorry if this should be obvious, but is there a reason your not using
>> your own internal lock for serializing the efi bits rather then using
>> the rtc_lock?
>
>Jan wrote the original code that started using the rtc_lock inside the
>EFI bits here, ef68c8f87ed1 ("x86: Serialize EFI time accesses on
>rtc_lock").
>
>Jan?
 
Matthew Garrett already replied to this - it's (on x86) a requirement of the EFI spec.

Jan

