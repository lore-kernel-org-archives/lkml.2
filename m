Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab1DNJlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:41:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab1DNJlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=E2tDqaj72m5MF5IpliQ3hX42A0kDDznkw6pcsSuLaS1s+hV+O52OhUyLWsRDJYS9R9
         KP7JS7ZulgHXRhtCm+ZEQjv2Lxx2klgZLnr7zrk+J9ybyRF5IC8fYnX7b8cWVnC9aUfz
         CM75F0gZiOml/ubSCJW7THd2qmuaO4mfYOsJc=
Message-ID: <4DA6C129.8010001@suse.cz>
Date: Thu, 14 Apr 2011 11:40:57 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, jirislaby@gmail.com,
        Robert Hancock <hancockrwd@gmail.com>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <4C87A62E.30108@gmail.com> <1302598086-3622-1-git-send-email-jslaby@suse.cz> <20110412085622.43488ed9@jbarnes-desktop> <20110412155921.GA531@srcf.ucam.org>
In-Reply-To: <20110412155921.GA531@srcf.ucam.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 05:59 PM, Matthew Garrett wrote:
> On Tue, Apr 12, 2011 at 08:56:22AM -0700, Jesse Barnes wrote:
> 
>> I'll defer to the ACPI experts, Len or Matthew have you checked this
>> one out?
> 
> Windows appears to work without this, so it seems likely that we're 
> doing something wrong in some other sense, but I don't think we have a 
> good idea as to what we're doing wrong...

Is there anything I can do about that? Provide some info, investigate
what a particular code does in the kernel (e.g. acpi_pci_irq_enable) etc.?

thanks,
-- 
js
suse labs
