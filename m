Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1GLViP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:38:15 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:7121 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754037Ab1GLViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:38:14 -0400
Message-ID: <4E1CBE5E.5090404@draigBrady.com>
Date: Tue, 12 Jul 2011 22:36:30 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] watchdog reboot timeout
References: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com> <4E15B9FD.8080003@draigBrady.com> <CAErSpo5=TQm9SLM9dE2-Sm7ZLvaSXAZOorE1z9SK9kEh9CUbNQ@mail.gmail.com>
In-Reply-To: <CAErSpo5=TQm9SLM9dE2-Sm7ZLvaSXAZOorE1z9SK9kEh9CUbNQ@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/11 17:25, Bjorn Helgaas wrote:
> On Thu, Jul 7, 2011 at 7:51 AM, Pádraig Brady <P@draigbrady.com> wrote:
>> A related issue I noticed with iTCO_wdt is that something
>> else in the kernel disables the iTCO watchdog (which my BIOS had started).
>> This is undesirable for obvious reasons.
> 
> This sounds related to iTCO, but unrelated to my patch.  Right?

Right, unrelated to your patch but it could affect you.
As the kernel comes up it may reinit the iTCO, disabling
the watchdog until the iTCO_wdt module is loaded and patted.

cheers,
Pádraig.
