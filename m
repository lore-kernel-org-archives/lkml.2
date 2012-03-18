Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2CRLVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 07:21:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:3198 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901Ab2CRLVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 07:21:49 -0400
Subject: Re: EFI Boot Stub Early Console
From: Matt Fleming <matt.fleming@intel.com>
To: Shea Levy <shea@shealevy.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4F648DD3.3000405@shealevy.com>
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com>
	 <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>
	 <4F5E775D.7080702@zytor.com>  <4F648DD3.3000405@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Sun, 18 Mar 2012 11:21:41 +0000
Message-ID: <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 09:12 -0400, Shea Levy wrote:
> On 3/12/12 6:23 PM, H. Peter Anvin wrote:
> > I don't think anyone has implemented an EFI earlyconsole yet
> 
> I'm considering taking a shot at this. Do you have any pointers about
> where to look or how to approach it? Will I have to use UGA/GOP or is
> there some way to take advantage of the text console after
> exit_boot_services?

I don't think you'll need to use the graphics protocols, you should just
be able to put something together using the 'output_string' function
from the EFI simple text output protocol, e.g. something like this,

	https://lkml.org/lkml/2012/3/16/193


