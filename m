Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0FOP3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:29:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab0FOP3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:29:08 -0400
Message-ID: <4C179C3E.6000702@redhat.com>
Date: Tue, 15 Jun 2010 17:29:02 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a	chance
 to veto it
References: <1276113907-22432-1-git-send-email-mjg@redhat.com> <4C17983F.8020405@redhat.com> <20100615151849.GA19895@srcf.ucam.org>
In-Reply-To: <20100615151849.GA19895@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 05:18 PM, Matthew Garrett wrote:
> On Tue, Jun 15, 2010 at 05:11:59PM +0200, Tomas Henzl wrote:
>
>   
>> Matthew, isn't it so that the POLICY_DEFAULT will pass the above test
>> and possibly switch the ASPM on?
>>     
> Yes. We assume that the BIOS authors aren't actively malicious.
>   
I originally thought your patch is about not enabling ASPM on broken 
hardware (bios included) before the driver has a chance to change it.

Sorry for the confusion, I was wrong with the bios.

tomas


