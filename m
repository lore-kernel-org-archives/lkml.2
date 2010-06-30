Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0F3Jkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:40:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:62049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0F3Jko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hOEYKF4Pw/VAIQ/BwU7PajUBOX2N6z33Ppn+21kuoax1JFho8b0qBzl6t19pNOvPvs
         +Jb+k8LcCN/xeo+m3mePPbBRRnvOVozFpD5a+YMkXxFmZCQXjGGFajiyqMjcvp/k83fD
         elu5UlAvZrFibGb5+r2ebI4wGvHW50H7lIuFk=
Message-ID: <4C2B1127.50203@suse.cz>
Date: Wed, 30 Jun 2010 11:40:55 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
CC: Robert Hancock <hancockrwd@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org>	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>	<4C2A3E27.4060407@suse.cz> <AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com> <4C2B0C73.9050200@suse.cz>
In-Reply-To: <4C2B0C73.9050200@suse.cz>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 11:20 AM, Jiri Slaby wrote:
> I still no point in comparing this to Windows' setup. We can't find out
> whether it is quirked or better (without some bug) handled there.

Whatever, how can one find the interrupt links setup on windows?
Something like
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 9 10 *11 12)
etc.? Without that it doesn't make much sense.

regards,
-- 
js
suse labs
