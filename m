Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0LUSPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:15:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0LUSPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:15:54 -0500
Message-ID: <4D10EED0.2030507@redhat.com>
Date: Tue, 21 Dec 2010 20:15:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sheng Yang <sheng@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <4D10E0C2.3020000@goop.org>
In-Reply-To: <4D10E0C2.3020000@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 07:15 PM, Jeremy Fitzhardinge wrote:
> On 12/20/2010 10:18 PM, Sheng Yang wrote:
> >  Then we can reuse it for Xen later.
>
> You should probably get someone kvm-ish to ack this too.

Looks good to me.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

