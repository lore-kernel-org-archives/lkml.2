Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0FZENb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 00:13:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43153 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0FZEN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 00:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ruqpCc+iMr4bZyfCEpZdungOuVv7//1wPfxZIIr7Khq68NZNYMQ/qh1ikAO+UkzSs0
         f8VOHNtCISf7lHTf49eQwFRFXEY0A4FSa3yACsj2YC761n06keVbiV98L8KDmkFvou10
         pGviWV9milBp+a4xvnbtX0rp/V8fkaHlLx2fU=
Message-ID: <4C257E67.9090101@gmail.com>
Date: Fri, 25 Jun 2010 22:13:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: amruth pattanada <amruth.vamadev@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Setting up Silicon image 3114 in DMA mode
References: <AANLkTinYuxwsLQKGRd6joRSCcbnns930DDienlhfEB8i@mail.gmail.com>
In-Reply-To: <AANLkTinYuxwsLQKGRd6joRSCcbnns930DDienlhfEB8i@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 02:25 AM, amruth pattanada wrote:
> Hi
> Can anybody please guide me what minimal steps to follow for setting
> up 3114 for operating in DMA mode and looked into linux 2.6.32.7 code.
> I am porting 3114 driver to RTOS but have problems in using BAR5 PCI
> config space because of Memory mapped region issues. I can access BAR4
> and plan to set up DMA mode.
> How do we access entire BAR5 memory space without using BAR5, is there
> any indirect way to access BAR5 using BAR4. Please let me know.
> Thanks
> Amruth p.v
> Sr.Embedded Engineer

See the datasheet (PCI Configuration Space section), there's a way to 
access BAR5 registers using indirect access registers in configuration 
space. I expect this will be relatively slow, however.
