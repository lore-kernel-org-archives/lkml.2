Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1AFOoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:44:13 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:47398 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab1AFOoL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:44:11 -0500
From: Carmelo AMOROSO <carmelo.amoroso@st.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Filippo ARCIDIACONO <filippo.arcidiacono@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 6 Jan 2011 15:43:33 +0100
Subject: Re: [PATCH 1/2] stackprotector: add stack smashing protector
	generic implementation
Thread-Topic: [PATCH 1/2] stackprotector: add stack smashing protector
	generic implementation
Thread-Index: AcutsBjeXkdPybo1ScG0ZY7Wqp6QzA==
Message-ID: <4D25D515.9060202@st.com>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com>
 <4D245D16.5010702@st.com> <20110106093940.GA31708@n2100.arm.linux.org.uk>
 <4D25CEB9.7090205@st.com> <20110106141946.GE31708@n2100.arm.linux.org.uk>
In-Reply-To: <20110106141946.GE31708@n2100.arm.linux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-enigmail-version: 1.1.1
user-agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/6/2011 3:19 PM, Russell King - ARM Linux wrote:
> On Thu, Jan 06, 2011 at 03:16:25PM +0100, Carmelo AMOROSO wrote:
>  > Well, SH (in CC) does not have this support. Indeed we posted it
>  > initially to linux-sh only. We got useful feedback from Paul, Mike and
>  > Nicolas suggesting to promote the ARM/SH solution based on the global
>  > __stack_chk_guard variable as a generic solution for all other
>  > architectures. This is why I thought to post to the LKML instead of each
>  > linux-<arch> list.
> 
> Have you thought about posting it to _the_ linux-arch list?
> 
I did not know this list. I'll do. Thanks.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0l1RUACgkQoRq/3BrK1s8a1gCgpSdHez/S8cJ8BM5jVhYH0TKy
84gAnRkeALaLGMoXJqtxdDRL7Xusc6JT
=L6Oj
-----END PGP SIGNATURE-----
