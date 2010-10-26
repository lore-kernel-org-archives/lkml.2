Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab0JZNPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:15:48 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:47326 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165Ab0JZNPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:15:47 -0400
Message-ID: <4CC6D440.10604@linux.vnet.ibm.com>
Date: Tue, 26 Oct 2010 11:14:40 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: debora@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: Autodetect itpm devices
References: <1287697360-31273-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1287697360-31273-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/10 19:42, Matthew Garrett wrote:
> Some Lenovos have TPMs that require a quirk to function correctly. This can
> be autodetected by checking whether the device has a _HID of INTC0102. This
> is an invalid PNPid, and as such is discarded by the pnp layer - however
> it's still present in the ACPI code, so we can pull it out that way. This
> means that the quirk won't be automatically applied on non-ACPI systems,
> but without ACPI we don't have any way to identify the chip anyway so I
> don't think that's a great concern.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
Thanks Matthew,

I'd be glad to remove the module option after this patch, but the 
non-ACPI case wouldn't
remain covered indeed.

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

