Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2LDON7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:13:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2LDONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:13:46 -0500
Date: Tue, 4 Dec 2012 15:13:33 +0100
From: Robert Richter <rric@kernel.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Yang Wei <wei.yang@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jun Zhang <jun.zhang@intel.com>
Subject: Re: [ 06/37] x86-32: Fix invalid stack address while in softirq
Message-ID: <20121204141333.GA13717@rric.localhost>
References: <20121130183857.166228045@linuxfoundation.org>
 <20121130183857.883260247@linuxfoundation.org>
 <20121204134257.GD2984@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204134257.GD2984@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.12 11:42:58, Herton Ronaldo Krzesinski wrote:
> Hi, this makes build fail with oprofile on i386 on 3.0.54:
> ERROR: "kernel_stack_pointer" [arch/x86/oprofile/oprofile.ko] undefined!
> 
> The following commit should address this failure:
> 
> commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Tue Nov 20 22:21:02 2012 -0800
> 
>     x86-32: Export kernel_stack_pointer() for modules

Correct. I checked the stable Git trees and it is not in 3.0 and 3.4.
My former statement was wrong, got a bit confused about which patch
was added to which tree, sorry.

-Robert
