Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0HQHSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:18:15 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:32845 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0HQHSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:18:14 -0400
Message-ID: <4C6A37B3.70605@neli.hopto.org>
Date: Tue, 17 Aug 2010 09:18:11 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/9] RapidIO: Add switch-specific sysfs initialization
 callback
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-7-git-send-email-alexandre.bounine@idt.com> <4C692E4C.4040300@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5FFC@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5FFC@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
>> Why not make a sw_sysfs_create and sw_sysfs_remove? Is better for
>> readability. Now you call 'sw_sysfs(dev, 0)' or 'sw_sysfs(dev, 1)';
> 
> I just do not want to have an extra member here. Not every switch will
> require own sysfs attributes, but every switch will be presented by a
> data structure. Based on its intended use I do not see any problem here.

It's not problematic, but personally I find function calls that pass 0 
or 1 as an argument hard to read. Likewise for boolean parameters. An 
alternative would be to have defines SW_SYSFS_CREATE etc. It's a minor item.

Micha
