Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0LQBVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:21:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45902 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0LQBVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:21:50 -0500
Message-ID: <4D0ABB0E.9080601@zytor.com>
Date: Thu, 16 Dec 2010 17:21:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com> <4D0A3E31.4000109@zytor.com> <4D0A4C51.3070008@kernel.org> <4D0A6F66.1010006@zytor.com> <4D0AA116.4050707@kernel.org> <4D0AA592.3060805@kernel.org> <4D0AB14F.9050900@kernel.org>
In-Reply-To: <4D0AB14F.9050900@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 04:39 PM, Yinghai Lu wrote:
> 
> and use that to estimate BRK size.
> 
> so we could change the BRK calculating code to handle 896M or just limit crashkernel for 32bit to 512M...
> 

Thinking about it, we probably should *both* fix the brk and limit the
crashkernel to 512 MiB (for compatibility with older crashkernels.)

	-hpa
