Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab1CDTyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:54:40 -0500
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:54358 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab1CDTyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:54:38 -0500
Message-ID: <4D714357.3010807@neli.hopto.org>
Date: Fri, 04 Mar 2011 20:53:59 +0100
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
References: <4D583E31.4070507@neli.hopto.org> <20110304103634.4641ae36@jbarnes-desktop>
In-Reply-To: <20110304103634.4641ae36@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sun, 13 Feb 2011 21:25:21 +0100
> Micha Nelissen <micha@neli.hopto.org> wrote:
> 
>> Patch is based on earlier patch from Matthew Wilcox.
> 
> I like this before when Matthew was working on it too

If I understood Thomas' concerns well, it sounds like this feature is 
inherently incompatible with big SMP systems. Therefore it has no chance 
of ever being accepted into mainline in whatever form?

Micha
