Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0IHPF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:05:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab0IHPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ljMSV+naHojnK//TltLUy/6lR9jjMdzousL6cpS9h8XNmGVlY+mSsxc08N4fA+HR9O
         a9CfJeNheee4vS5PwHKnTavf5IoHW1kdr9HBwDgP1gnI2o0UE+C8KCUPQKpylESBHiUh
         xCbiB7yTkszYeSVa+PVvN97iL18uTl6eGZFmA=
Message-ID: <4C87A62E.30108@gmail.com>
Date: Wed, 08 Sep 2010 17:05:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org>	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>	<4C2A3E27.4060407@suse.cz>	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>	<4C2B0C73.9050200@suse.cz>	<4C3278C8.60503@gmail.com>	<4C447D6D.5060801@suse.cz>	<AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>	<4C456C69.60606@suse.cz>	<4C737E9F.7060107@gmail.com>	<AANLkTin7eUS7_y9J8iY1XFi2bRnpm+WqFNT_tBopwyCK@mail.gmail.com>	<4C7B5F64.30205@suse.cz>	<4C861BB9.2000707@gmail.com> <AANLkTi=bnr-tnTkCWuSqYhLkfnXhJQjSyLDTt_5RyiAN@mail.gmail.com>
In-Reply-To: <AANLkTi=bnr-tnTkCWuSqYhLkfnXhJQjSyLDTt_5RyiAN@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 04:40 PM, Robert Hancock wrote:
> I'd suggest opening a report on kernel.org bugzilla under ACPI and
> attach the acpidump output..

Done:
https://bugzilla.kernel.org/show_bug.cgi?id=18092

thanks,
-- 
js
