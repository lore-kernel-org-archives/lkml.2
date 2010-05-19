Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0ESRvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:51:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40609 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab0ESRvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:51:08 -0400
Message-ID: <4BF424FE.80400@zytor.com>
Date: Wed, 19 May 2010 10:50:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ky Srinivasan <ksrinivasan@novell.com>
CC: greg@kroah.com, hjanssen@microsoft.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/2] Hyperv detection - code cleanup
References: <4BF3C97F020000300008560D@sinclair.provo.novell.com>
In-Reply-To: <4BF3C97F020000300008560D@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 10:20 AM, Ky Srinivasan wrote:
> From: K. Y. Srinivasan <ksrinivasan@novell.com>
> Subject: Code cleanup - get rid of the "ms" prefix in hyperv related files.  
> 
> 
> Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>

NAK in the extreme.

"hyperv" -- without the capitalization to make it stand out -- is way
too easy to read as just an abbreviation for "hypervisor".

	-hpa
