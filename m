Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2FOQ3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:29:20 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:57387 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932376Ab2FOQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:29:19 -0400
Message-ID: <4FDB62CD.50707@xenotime.net>
Date: Fri, 15 Jun 2012 09:29:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 14 (leds)
References: <20120614162901.798d7661ea87e6134eee6f3a@canb.auug.org.au> <4FDA5C8B.401@xenotime.net> <CAK5ve-JMkdir+NcKq47hBQ4Jcbh2WkqeiSohqp3AcQchbsMe5w@mail.gmail.com>
In-Reply-To: <CAK5ve-JMkdir+NcKq47hBQ4Jcbh2WkqeiSohqp3AcQchbsMe5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 08:42 PM, Bryan Wu wrote:

> On Fri, Jun 15, 2012 at 5:50 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 06/13/2012 11:29 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120613:
>>>
>>> Linus' tree gained a build failure for which I reverted a commit.
>>>
>>> The net-next tree lost its conflicts but gained another against the
>>> wireless tree.
>>>
>>> The sound-asoc tree lost its build failure.
>>>
>>> The leds tree lost its build failure.
>>>
>>> ----------------------------------------------------------------------------
>>>
>>> I have created today's linux-next tree at
>>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
>>> are tracking the linux-next tree using git, you should not use "git pull"
>>> to do so as that will try to merge the new linux-next release with the
>>> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
>>> (see below).
>>>
>>> You can see which trees have been included by looking in the Next/Trees
>>> file in the source.  There are also quilt-import.log and merge.log files
>>> in the Next directory.  Between each merge, the tree was built with
>>> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
>>> final fixups (if any), it is also built with powerpc allnoconfig (32 and
>>> 64 bit), ppc44x_defconfig and allyesconfig (minus
>>> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
>>> and sparc64 defconfig. These builds also have
>>> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
>>> CONFIG_DEBUG_INFO disabled when necessary.
>>>
>>> Below is a summary of the state of the merge.
>>>
>>> We are up to 189 trees (counting Linus' and 26 trees of patches pending
>>> for Linus' tree), more are welcome (even if they are currently empty).
>>> Thanks to those who have contributed, and to those who haven't, please do.
>>>
>>> Status of my local build tests will be at
>>> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
>>> advice about cross compilers/configs that work, we are always open to add
>>> more builds.
>>>
>>> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
>>> Gortmaker for triage and bug fixes.
>>>
>>> There is a wiki covering stuff to do with linux-next at
>>> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
>>
>>
>>
>> on i386:
>>
>> ERROR: "led_brightness_set" [drivers/leds/led-class.ko] undefined!
>> ERROR: "leds_list" [drivers/leds/led-class.ko] undefined!
>> ERROR: "leds_list_lock" [drivers/leds/led-class.ko] undefined!
>>
>> and possibly related:
>>
>> warning: (ADB_PMU_LED && IWLWIFI && IWLEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS && TABLET_USB_WACOM && INPUT_WISTRON_BTNS && SENSORS_APPLESMC && IR_WINBOND_CIR && BACKLIGHT_ADP8860 && BACKLIGHT_ADP8870 && HID_LENOVO_TPKBD && ACER_WMI && ASUS_LAPTOP && DELL_LAPTOP && HP_ACCEL && THINKPAD_ACPI && EEEPC_LAPTOP && ASUS_WMI && ACPI_TOSHIBA && SAMSUNG_LAPTOP) selects LEDS_CLASS which has unmet direct dependencies (NEW_LEDS)
>>
>>
>> Full randconfig file is attached.
>>
> 
> Hi Randy,
> 
> I tried to build linux-next latest kernel with the randconfig you
> posted here, but didn't met this building failure. Did I miss
> something?


I dunno, but I still get the same failure with that kernel config file
on today's linux-next (20120615).


-- 
~Randy
