Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1JZKAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 06:00:19 -0400
Received: from mail-bw0-f66.google.com ([209.85.214.66]:56217 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab1JZKAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 06:00:17 -0400
MIME-Version: 1.0
Reply-To: lenb@kernel.org
In-Reply-To: <CAErSpo4EtfhnhWGpahk-NfMUVEizZSk3igZ+Vy7x=+hY5b0bcw@mail.gmail.com>
References: <4EA549C3.4080206@ntlworld.com>
	<CAErSpo4EtfhnhWGpahk-NfMUVEizZSk3igZ+Vy7x=+hY5b0bcw@mail.gmail.com>
Date: Wed, 26 Oct 2011 06:00:15 -0400
Message-ID: <CAJvTdKmeEGVz8fXhaoFUOCtMM4bufTraTvztrf93880a1sVqKw@mail.gmail.com>
Subject: Re: kernel panic
From: Len Brown <lenb417@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: nick bray <nick.bray1@ntlworld.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  after upgrading to linux kernel 3.xx I get kernel panic on boot unless I
>> use ACPI=off in the boot parameters this happens with both Ubuntu 11.10 and
>> Fedora 16. The mainboard is an Intel S875WP1-E running a Pentuim 4 3ghz with
>> 3gig RAM in single-channel mode. I have performed a Bios upgrade just in
>> case tha ACPI tables were corrupt but it makes no difference. Currently
>> running 2.6.38-11-generic #50-Ubuntu SMP (Linux Mint) with no issues.

Is this problem new in 3.1, or is it also present in 2.6.39 or 3.0?

Also, do any other cmdline parmaters besides acpi=off work-around it?
pci=noacpi
maxcpus=1

etc.

thanks,
Len Brown, Intel Open Source Technology Center
