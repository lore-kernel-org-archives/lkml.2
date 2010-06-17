Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab0FQJiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:38:06 -0400
Received: from claw.goop.org ([74.207.240.146]:35303 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab0FQJiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:38:04 -0400
Message-ID: <4C19ECF8.1090600@goop.org>
Date: Thu, 17 Jun 2010 10:38:00 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com> <4C19BA9A.4010300@zytor.com> <4C19EC57.3000409@goop.org>
In-Reply-To: <4C19EC57.3000409@goop.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 10:35 AM, Jeremy Fitzhardinge wrote:
> I guess it would be possible to special-case ioremap to allow the
> creation of such mappings, but I don't know what kind of system-wide
> fallout would happen as a result.  The consequences of something trying
> to extract a pfn from one of those ptes would be
>   

...very bad, as it would result in truncated pfns and likely cause some
kind of corruption.

(oops, sent too early)

    J
