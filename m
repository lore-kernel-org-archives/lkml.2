Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2CWQHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:07:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:43903 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab2CWQHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:07:10 -0400
Subject: Re: [PATCH 00/17] Platform Facilities Option and crypto accelerator driver
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1332443286.3858.70.camel@key-ThinkPad-W510>
Date: Fri, 23 Mar 2012 11:06:50 -0500
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <06B7F1E7-951D-4753-BE00-7B0C84BACDAE@kernel.crashing.org>
References: <1332365297.3858.5.camel@key-ThinkPad-W510> <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org> <1332443286.3858.70.camel@key-ThinkPad-W510>
To: Kent Yoder <key@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22, 2012, at 2:08 PM, Kent Yoder wrote:

> Hi Kumar,
> 
>> Is there a reason this isn't in drivers/crypto/
> 
>  Other arch-specific dirs have their crypto subdir as well such as
> arch/s390.  I was just matching that.
> 
> Kent
> 
>> - k
> 

>From what I can tell this isn't ISA level instructions and thus should NOT be in arch/powerpc.  This should be moved into drivers/crypto

- k