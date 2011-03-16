Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1CPPyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:54:04 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51699 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab1CPPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:53:58 -0400
Subject: Re: [PATCH] device: add dev_WARN_ONCE
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Felipe Balbi <balbi@ti.com>
In-Reply-To: <20110316143934.GA16166@suse.de>
Date: Wed, 16 Mar 2011 17:53:53 +0200
Cc: Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <damm@opensource.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <7DD6AD65-0F6E-402E-BE8D-05E03E56E03E@ti.com>
References: <1300283975-27556-1-git-send-email-balbi@ti.com> <20110316143934.GA16166@suse.de>
To: Greg KH <gregkh@suse.de>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 16, 2011, at 4:39 PM, Greg KH wrote:

> On Wed, Mar 16, 2011 at 03:59:35PM +0200, Felipe Balbi wrote:
>> it's quite useful to print the device name
>> on the stack dump caused by WARN(), but
>> there are other cases where we might want
>> to use WARN_ONCE.
>> 
>> Introduce a helper similar to dev_WARN() for
>> that case too.
>> 
>> Signed-off-by: Felipe Balbi <balbi@ti.com>
> 
> Do you have code that needs this for .39, or can it wait for .40?

it can definitely wait :-)

-- 
balbi

