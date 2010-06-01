Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0FAUGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:06:04 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:35709 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab0FAUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=D44b9cff3r1aTq+VdZvse/ibVVpybLd4lhlJGVdv5d/99ZhDXxKO/0e1/S0pBX7evA
         45Wn7Z2POGRulxvHFmFQF2Lrgt7bl6wvedDZoViME2xYvLogmudRmsYUNQZmu8YjpouP
         u1dDvGzSFCE8xNKLlwAoriMopCimz/aOR3Oa0=
Message-ID: <4C056839.8020605@gmail.com>
Date: Tue, 01 Jun 2010 13:06:17 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <1275114371-5329-1-git-send-email-justinmattock@gmail.com> <20100531170745.GA21225@srcf.ucam.org> <4C03F5EF.8080302@gmail.com> <20100601190050.GA14667@srcf.ucam.org> <4C055BFF.8090800@gmail.com> <20100601192101.GA15086@srcf.ucam.org>
In-Reply-To: <20100601192101.GA15086@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 12:21 PM, Matthew Garrett wrote:
> On Tue, Jun 01, 2010 at 12:14:07PM -0700, Justin P. Mattock wrote:
>
>> o.k. applied.. unfortunately
>> I get init telling me it's rebooting,
>> then, nothing but a black screen.
>
> Could you send me the output of acpidump on this machine? Also, try
> building the following app and running it as root:
>
> #include<sys/io.h>
>
> int main() {
> 	outb(6, 0xcf9);
> 	return 0;
> }
>
> and see if the machine reboots.
>

nope.. here is what I get:
./reboot
Segmentation fault (core dumped)

and in dmesg:
[ 1401.323601] reboot[3615] general protection ip:40048b
sp:7fff2a601910 error:0 in reboot[400000+1000]


Justin P. Mattock
