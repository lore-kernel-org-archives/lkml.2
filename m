Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0F2Ske (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:40:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38991 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0F2Skb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=r4uI8JbZzqM6GKbwnyd7guPYiCDGTYCt8jlAhDXCb6zkMdCYfjvB8g5LX6reO0WRYW
         oNeo9FERSpmf2gMUchgyQrfLb/J2itjAn5Q8yJuefTiwMRV3kLKh3bjWCidNT1CR9weO
         gFV17aFfrpNmObJNSk0W3JMT1dNJluf3RYsLo=
Message-ID: <4C2A3E27.4060407@suse.cz>
Date: Tue, 29 Jun 2010 20:40:39 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org> <AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>
In-Reply-To: <AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 11:37 PM, Robert Hancock wrote:
> On Mon, Jun 28, 2010 at 2:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> I can guarantee to you that a generic Windows install does not have a
>> quirk for an IBM PoS system released years after that CD was pressed.

The system in question is very old, any current Windows release is newer
than that.

>> The relevance is that if Windows works without a quirk, then somewhere
>> our behaviour diverges from that of Windows and it's likely that other
>> machines are also hit by the same issue. Users of those systems may not
>> have a support contract with a commercial Linux vendor and may just
>> decide to use Windows instead, so there's an incentive for us to
>> determine if that's the case and fix Linux's behaviour to match Windows
>> rather than to just quirk over it.
> 
> Exactly, this seems like a pretty obvious failure, so either IBM's
> testing on this machine under Windows was hopelessly inadequate and it
> is broken there too, or else Windows is doing something different and
> maybe we should be doing the same thing..

The answer I got is "it works there with a driver" whatever it means
(I'm no expert on windows drivers and have no idea what they can do and
what quirks can be implemented that way).

regards,
-- 
js
suse labs
