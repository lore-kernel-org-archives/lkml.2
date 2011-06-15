Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1FOUik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:38:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33667 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1FOUih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eWrWhbquKK7eCf4eq3lh3kq7mkoFQ3nfNqjDFrzsXEdxGg7/6rg65uyjWPtR6ppgBD
         H2FAwdZrW0rA9QVzwYY+E0zjegWsFzS5gMYJLzl8Tc6dP89PPHbtrHNdvTvGRjrAvZA7
         XR3EwLYT+ZxHyrzYL6/JpVSJIFrk+B2zEYkNk=
Message-ID: <4DF9184A.9030308@gmail.com>
Date: Wed, 15 Jun 2011 22:38:34 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Add reset on resume quirk for asrock p67 host
References: <4DF85A1F.1080001@gmail.com> <20110615165842.GB5382@xanatos> <4DF8EE62.3060407@gmail.com> <20110615195928.GD5382@xanatos> <4DF9160D.8090109@gmail.com> <20110615203631.GF5382@xanatos>
In-Reply-To: <20110615203631.GF5382@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

Op 15-06-11 22:36, Sarah Sharp schreef:
> On Wed, Jun 15, 2011 at 10:29:01PM +0200, Maarten Lankhorst wrote:
>> The asrock p67 xhci controller completely dies on resume,
>> add a quirk for this, to bring the host back online after a suspend.
>>
>> This should be backported to stable kernels as far back as 2.6.34.
> Why 2.6.34?  Only kernels as old as 2.6.37 had xHCI suspend and resume
> support.  Before 2.6.37, the xHCI driver would prevent the system from
> suspending at all.
Oh my bad, I was just looking at my previous commit, expected
resume to already be available since xhci was in the kernel for so long.

Should I resend or will you amend the commit message?

~Maarten
