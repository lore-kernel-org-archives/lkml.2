Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1BJXtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:49:10 -0500
Received: from claw.goop.org ([74.207.240.146]:46131 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab1BJXtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:49:08 -0500
Message-ID: <4D547962.8040403@goop.org>
Date: Thu, 10 Feb 2011 15:48:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com> <alpine.DEB.2.00.1102041130060.7277@kaball-desktop> <4D4CA568.70907@goop.org> <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop> <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org> <4D50B4B5.4050505@kernel.org> <4D519AAA.8070309@zytor.com>
In-Reply-To: <4D519AAA.8070309@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 11:34 AM, H. Peter Anvin wrote:
> On 02/07/2011 07:12 PM, Yinghai Lu wrote:
>> why punishing native path with those checking?
>>
> What happens if you end up with a reserved range in an unfortunate place
> on real hardware?

Yes, exactly.  The reserved region code isn't very useful if you can't
rely on it to reserve stuff.

    J
