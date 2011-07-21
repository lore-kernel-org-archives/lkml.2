Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1GUVgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:36:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49366 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab1GUVgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <4E289939.2080004@zytor.com>
References: <3ae5ec76a168eaaae63f08a2a1060b91aa0b7759.1310563276.git.luto@mit.edu>
 <tip-433bd805e5fd2c731b3a9025b034f066272d336e@git.kernel.org>
 <4E288AA6.7090804@zytor.com> <CAObL_7HyKSwm9a_7nfdk5E0Noy5zqD=dyaanvxY_iX5XcP1d4Q@mail.gmail.com>
 <4E28934A.6040200@zytor.com> <CAObL_7Gpf8Ux=unueB5y41p=O2dHPjZ_eVW+g6Es8N6TH4nLXg@mail.gmail.com>
 <4E289939.2080004@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 21 Jul 2011 17:36:25 -0400
X-Google-Sender-Auth: lyFIfKT-cKaPjh_FrJ0ji326tGI
Message-ID: <CAObL_7EEh+fO23OkpN=zTM5KrHy8FisfPjXkJ7K7k74YsE503w@mail.gmail.com>
Subject: Re: [tip:x86/vdso] clocksource: Replace vread with generic arch data
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, clemens@ladisch.de,
        linux-tip-commits@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 5:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/21/2011 02:22 PM, Andrew Lutomirski wrote:
>>
>> Presumably this needs a matching fix:
>>
>> http://git.kernel.org/?p=linux/kernel/git/tip/linux-tip.git;a=commit;h=574c44fa8fa6262ffd5939789ef51a6e98ed62d7
>>
>> (Also, none of the IA-64 maintainers have replied to any of my
>> requests for review.)
>>
>
> What do you mean, "matching fix"?  The fix I posted should work on x86
> and ia64.
>

*sigh* I read it wrong.  Never mind.

--Andy
