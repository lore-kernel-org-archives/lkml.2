Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1F1TxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:53:22 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:59146 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1F1TxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:53:16 -0400
Message-ID: <4E0A3124.5040809@free-electrons.com>
Date: Tue, 28 Jun 2011 21:53:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Make Dell Latitude E6320 use reboot=pci
References: <1309269451-4966-1-git-send-email-maxime.ripard@free-electrons.com> <20110628174137.GA18115@srcf.ucam.org> <4E0A2D0C.6030701@free-electrons.com>
In-Reply-To: <4E0A2D0C.6030701@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/2011 21:35, Maxime Ripard wrote:
> On 28/06/2011 19:41, Matthew Garrett wrote:
>> On Tue, Jun 28, 2011 at 03:57:31PM +0200, Maxime Ripard wrote:
>>> The Dell Latitude E6320 doesn't reboot unless reboot=pci is set.
>>
>> On which kernel versions?
>
> All the versions from 2.6.38 to 3.0-rc5.

I am not saying this is a regression though. I just didn't test it with 
an earlier kernel.


-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
