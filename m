Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0GAAd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:33:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61529 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab0GAAdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mF/SlLX+SNwIyAlxj+d9Y+ztz4/5PJkQ7sn6ieTa82UICNPf6GZrqiNX4qhlIHEvSH
         LFQi42cqPw71capKhVJkO2IjbQEFrNuL04OtuJoan5IPFlOzmn1bNZtpVQ3pgXxVdj+g
         bWrgdw/9YNu7ARAIG0aLXfwzLICt9Rz6cS7Yw=
Message-ID: <4C2BE243.5040308@garzik.org>
Date: Wed, 30 Jun 2010 20:33:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: amruth pattanada <amruth.vamadev@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Setting up Silicon image 3114 in DMA mode
References: <AANLkTinYuxwsLQKGRd6joRSCcbnns930DDienlhfEB8i@mail.gmail.com> <4C257E67.9090101@gmail.com> <AANLkTikeQO1v-ag_DDbkgxoZRTk1_fomn1kbHKqH9vkD@mail.gmail.com> <AANLkTimOu5GfUN848EOiMIZONHrRjgYyexmwBL3OCAMs@mail.gmail.com>
In-Reply-To: <AANLkTimOu5GfUN848EOiMIZONHrRjgYyexmwBL3OCAMs@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 08:30 AM, amruth pattanada wrote:
> Hi
> I need some clarification regarding read DMA data from silicon image
> controller. How do know that DMA transfer happened and where to look
> for the data after the transfer. Should we look at BAR2 channel X Task
> file register data word or look into allocated DMA buffer which is
> specified in the PRD table. I am reading 0x00 in the PRD table scatter
> gather list and it hangs in the when I tried to read data word of
> channel task file register. Please let me know how to read data buffer
> after the DMA is complete.

Teaching you how to write a non-Linux driver is outside the scope of 
linux-ide and linux-kernel.  This information is covered by the freely 
available Silicon Image documentation, and SiI support should be able to 
assist you further beyond that.

	Jeff



