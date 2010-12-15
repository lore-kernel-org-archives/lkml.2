Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0LOWmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:42:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50949 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0LOWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:42:34 -0500
Message-ID: <4D094411.2020303@kernel.org>
Date: Wed, 15 Dec 2010 14:41:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com>
In-Reply-To: <20101215103954.GA2243@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 02:39 AM, Stanislaw Gruszka wrote:
> I could debug this problem, but I do not suffer from free time right
> now :-) Would be better someone bootmem/kdump experienced debug this.
> I just check other laptop (T500, 2.6.37-rc5, x86_64, RHEL6 user space,
> crashkernel=256M, 1.6G mem), kdump does not work there too. So I do
> think problem is hard to reproduce.

ok, will try to find some old machine with less memory and devices to duplicate the problem.

Yinghai
