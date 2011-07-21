Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1GUVGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:06:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1GUVGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:06:32 -0400
Message-ID: <4E28934A.6040200@zytor.com>
Date: Thu, 21 Jul 2011 13:59:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, clemens@ladisch.de,
        linux-tip-commits@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [tip:x86/vdso] clocksource: Replace vread with generic arch data
References: <3ae5ec76a168eaaae63f08a2a1060b91aa0b7759.1310563276.git.luto@mit.edu> <tip-433bd805e5fd2c731b3a9025b034f066272d336e@git.kernel.org> <4E288AA6.7090804@zytor.com> <CAObL_7HyKSwm9a_7nfdk5E0Noy5zqD=dyaanvxY_iX5XcP1d4Q@mail.gmail.com>
In-Reply-To: <CAObL_7HyKSwm9a_7nfdk5E0Noy5zqD=dyaanvxY_iX5XcP1d4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 01:49 PM, Andrew Lutomirski wrote:
> 
> Whoops.  If only cross-compiler toolchains were easy to build...
> 

http://www.kernel.org/pub/tools/crosstool/

> 
> If I don't hear any better suggestions, I'll implement that tomorrow.
> Do you want an incremental patch or a replacement?
> 

Already did, given the timing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

