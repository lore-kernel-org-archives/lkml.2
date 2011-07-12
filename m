Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1GLNNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:13:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1GLNNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:13:50 -0400
Message-ID: <4E1C488A.1020308@gmail.com>
Date: Tue, 12 Jul 2011 15:13:46 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Winkler, Tomas" <tomas.winkler@intel.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>
Subject: Re: [staging] mei: Enable msi when supported
References: <4E159945.8050900@gmail.com> <6F5C1D715B2DA5498A628E6B9C124F0401C711335D@hasmsx504.ger.corp.intel.com>
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401C711335D@hasmsx504.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

On 07/07/2011 02:23 PM, Winkler, Tomas wrote:
>> -----Original Message-----
>> From: Maarten Lankhorst [mailto:m.b.lankhorst@gmail.com]
>> Sent: Thursday, July 07, 2011 2:32 PM
>> To: Winkler, Tomas
>> Cc: devel@linuxdriverproject.org; Linux Kernel Mailing List
>> Subject: [staging] mei: Enable msi when supported
>>
>> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>> ---
>> Tested suspend/resume, driver (re/un)loading. Comments welcome. :)
> Sounds good, but I believe in case where MSI is enabled we also can kill the quick handler.
> Let me check before I ack this.

Figured I'd bump because I haven't heard anything back.

Cheers,
Maarten
