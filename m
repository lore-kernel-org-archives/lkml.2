Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0ESSSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:18:33 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:8805 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0ESSSc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:4:1>);
	Wed, 19 May 2010 14:18:32 -0400
Message-Id: <4BF3D7130200003000085657@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 19 May 2010 12:18:27 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <greg@kroah.com>, <hjanssen@microsoft.com>, "Avi Kivity" <avi@redhat.com>,
       <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Hyperv detection - code cleanup
References: <4BF3C7970200003000085602@sinclair.provo.novell.com>
 <4BF4252E.6090609@zytor.com>
In-Reply-To: <4BF4252E.6090609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 5/19/2010 at  1:51 PM, in message <4BF4252E.6090609@zytor.com>, "H. Peter
Anvin" <hpa@zytor.com> wrote: 
> On 05/19/2010 10:12 AM, Ky Srinivasan wrote:
>> 
>> From: K. Y. Srinivasan <ksrinivasan@novell.com>
>> Subject: Code cleanup - consolidate all hyperv related definitions into one
>> header file.
>> 
> 
> How will this affect KVM?  I was under the impression that this was
> separated out as a constants-only header file for a reason.

I was under the impression that hyperv.h was for all public definitions of  Hyperv. I am hoping Avi can shed some light on KVM implications (if any). 

Regards,

K. Y
> 
> 	-hpa


