Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1BDS6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:58:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44687 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1BDS6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:58:44 -0500
Message-ID: <4D4C4C4D.40106@zytor.com>
Date: Fri, 04 Feb 2011 10:58:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: John Villalovos <jvillalo@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "John L. Villalovos" <john.l.villalovos@intel.com>, prarit@redhat.com
Subject: Re: [PATCH 1/1] x86, apic: Make "broken BIOS!!" messages unique
References: <20110204174831.GA10370@intel-s3eb1-02.lab.bos.redhat.com>
In-Reply-To: <20110204174831.GA10370@intel-s3eb1-02.lab.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 09:48 AM, John Villalovos wrote:
> x86, apic: Make "broken BIOS!!" messages unique
> 
> There are five identical "broken BIOS!!" messages.  This patch makes each
> message unique so that it is easier to determine which message was actually
> printed.
> 
> The 'inconceivable' messages are because it should not be possible to reach
> those code paths.

How about labelling these "MPBIOS" or so, too?

	-hpa
