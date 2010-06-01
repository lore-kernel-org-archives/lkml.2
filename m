Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0FAUax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:30:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52957 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab0FAUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SP7i3p9DS5fSxLgMFT2wo2Jz/7yAZL4Y11LJICJlqLEMfr4ybDdhOMMemwB24cIAlF
         ksiZfKUsq9abP0nevLXds467n26BaG9m9uPI1PCeImamSHk7nZgnZnEJ+jeCOLJz78Uk
         NzbSbWWcTxxuqEbZ1WH2VtObUCProv3WP/nCI=
Message-ID: <4C056E0C.2030709@gmail.com>
Date: Tue, 01 Jun 2010 13:31:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <1275114371-5329-1-git-send-email-justinmattock@gmail.com> <20100531170745.GA21225@srcf.ucam.org> <4C03F5EF.8080302@gmail.com> <20100601190050.GA14667@srcf.ucam.org> <4C055BFF.8090800@gmail.com> <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org>
In-Reply-To: <20100601202130.GA16391@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 01:21 PM, Matthew Garrett wrote:
> On Tue, Jun 01, 2010 at 01:17:42PM -0700, Justin P. Mattock wrote:
>
>> still craps out.
>> this is what the code looks like now:
>
> You're running it as root, right? It behaves exactly as I'd expect here.
>

the first run of this was normally.
then root..
(and your right this time after the
change I forgot to do a su)
now running as root gives nothing.

Justin P. Mattock
