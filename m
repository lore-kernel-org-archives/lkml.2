Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2FPGdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:33:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38545 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2FPGdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <DFD0DA03-D72C-4B5D-9E56-AA214202400A@marvell.com>
References: <1339784856-1779-1-git-send-email-prakity@marvell.com>
	<CADTbHxpfQpKMkwzUakUUzt1mKO5rQ2A7_vuh9SA7i6Cq0VinZg@mail.gmail.com>
	<DFD0DA03-D72C-4B5D-9E56-AA214202400A@marvell.com>
Date: Sat, 16 Jun 2012 12:03:06 +0530
Message-ID: <CADTbHxrOWP02cCLD-gb3izE6QA-z70QEeCEW8J+V1sHt7dkyPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Philip Rakity <philipspatches@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jun 16, 2012 at 12:48 AM, Philip Rakity <prakity@marvell.com> wrote:
>
> On Jun 15, 2012, at 11:50 AM, Pankaj Jangra wrote:
>
>> Hi,
>>
>> On Fri, Jun 15, 2012 at 11:57 PM, Philip Rakity
>> <philipspatches@gmail.com> wrote:
>>> V3
>>> --
>>>
>>>
>>> The callin handler cannot call regulator_get_voltage() to get the
>>
>> "The calling"
>
> I am not sure what the correct term for this.  The blocking_notifier_call_chain calls
> what ?   calling might imply blocking_notifier_call_chain() since it is doing the calling.
> What is the receiver of the call named ?
>

I was trying to bring up the spelling typo s/callin/calling though

Regards,
Pankaj Jangra
