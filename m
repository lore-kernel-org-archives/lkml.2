Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1GUVnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:43:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54565 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1GUVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:42:59 -0400
Message-ID: <4E289D48.1060207@zytor.com>
Date: Thu, 21 Jul 2011 14:42:32 -0700
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
References: <3ae5ec76a168eaaae63f08a2a1060b91aa0b7759.1310563276.git.luto@mit.edu> <tip-433bd805e5fd2c731b3a9025b034f066272d336e@git.kernel.org> <4E288AA6.7090804@zytor.com> <CAObL_7HyKSwm9a_7nfdk5E0Noy5zqD=dyaanvxY_iX5XcP1d4Q@mail.gmail.com> <4E28934A.6040200@zytor.com> <CAObL_7Gpf8Ux=unueB5y41p=O2dHPjZ_eVW+g6Es8N6TH4nLXg@mail.gmail.com> <4E289939.2080004@zytor.com> <CAObL_7EEh+fO23OkpN=zTM5KrHy8FisfPjXkJ7K7k74YsE503w@mail.gmail.com>
In-Reply-To: <CAObL_7EEh+fO23OkpN=zTM5KrHy8FisfPjXkJ7K7k74YsE503w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 02:36 PM, Andrew Lutomirski wrote:
>>
>> What do you mean, "matching fix"?  The fix I posted should work on x86
>> and ia64.
>>
> 
> *sigh* I read it wrong.  Never mind.
> 

That's ok, better to say something and be wrong than to not say
something and be right...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

