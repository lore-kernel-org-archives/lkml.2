Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2IFOXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:23:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2IFOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:23:44 -0400
Message-ID: <5048B1E8.1020904@canonical.com>
Date: Thu, 06 Sep 2012 22:23:36 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
References: <1346910035.47691.188651047712.1.gpush@pecola> <1346941120.4244.82.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1346941120.4244.82.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

> Am I correct in thinking that this filesystem doesn't handle deletion of
> authenticated variables?

Unless I'm missing something, this should work fine; we just pass the 
EFI_VARIABLE_AUTHENTICATION_2 descriptor (with the usual attribute 
header), but no data following the descriptor.

Cheers,


Jeremy


