Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2JIFMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 01:12:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56622 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JIFL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 01:11:58 -0400
Message-ID: <5073B21B.4090600@kernel.org>
Date: Tue, 09 Oct 2012 01:11:55 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [bisected] PS/2 keyboard and mouse dead on resume on Intel D845BG
References: <201210071513.27959.linux@rainbow-software.org> <201210072100.09813.linux@rainbow-software.org> <20121008144243.GC5068@srcf.ucam.org>
In-Reply-To: <20121008144243.GC5068@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 10:42 AM, Matthew Garrett wrote:
> On Sun, Oct 07, 2012 at 09:00:09PM +0200, Ondrej Zary wrote:
> 
>> Added acpi_read_bit_register there and it seems that SCI_EN is already set!
>>
>> This patch fixes the problem here. I wonder how this affects systems that
>> require SCI_EN to be set.
> 
> I /think/ that this will be safe, but it doesn't match my recollection 
> of how Windows behaves so it may break something. Any chance you can 
> find someone with one of the machines mentioned in 
> https://bugzilla.kernel.org/show_bug.cgi?id=13745 and make sure that 
> they still work with your patch?

yikes.
we started with a white-list,
then we made setting SCI_EN the default,
and here is at least one box that wants to be on a black list
so that we don't set SCI_EN:-(



