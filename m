Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0IMDCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:02:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37713 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab0IMDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UshfzkgexVgBsDv8dtyawy691I9hHeFhRvSgOXS7nZW7AtQ4qrUtjxFOqk2qOoGGa5
         Pe0xVZqmZZUR8zR5pxE8K1zADeKZHCGzMIWZOUnEJJsrypUXny4ux197JG56EfD8K9W1
         cZjL3ZHHdW1AcbxoJYEiFfzRy8w5tdMseAqYg=
Message-ID: <4C8D9425.4060102@gmail.com>
Date: Mon, 13 Sep 2010 11:01:57 +0800
From: =?UTF-8?B?Ik1yLiBUZW8gRW4gTWluZyAoWmhhbmcgRW5taW5nKSDlvKDmganpuKMgbw==?=
	 =?UTF-8?B?ZiBTaW5nYXBvcmUi?= <space.time.universe@gmail.com>
Reply-To: space.time.universe@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>,
        LKML <linux-kernel@vger.kernel.org>,
        "Han, Weidong" <weidong.han@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian.Pratt@eu.citrix.com
CC: "space.time.universe@gmail.com" <space.time.universe@gmail.com>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: [Xen-devel] Requesting Assistance from Intel Engineers on Intel
 Integrated Graphics (IGD) VGA Passthrough for Xen 4.0.1-RELEASE and pv-ops
 dom0 kernel 2.6.32.x
References: <4C8B1A46.7010609@gmail.com> <20100911102129.GZ2804@reaktio.net> <4C8B698C.8000308@gmail.com> <4C8B9D95.7070701@gmail.com>
In-Reply-To: <4C8B9D95.7070701@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( EDIT: In case my email attachments are too big, I have uploaded my 
screenshots to image sharing sites.

Here are the links:

(1) http://img684.imageshack.us/img684/9672/inteligdvgapassthroughw.jpg

(2) http://i55.tinypic.com/23jhe0o.jpg

(3) http://imgur.com/92D5s.jpg )

Dear All,

I have barely managed to install Intel Graphics Media Accelerator (GMA) 
Drivers because the system is unstable and Windows XP Home Edition HVM 
domU keeps crashing with a BSOD after a short while. I have attached 
three screenshots of the Device Manager in this email. You may refer to 
these screenshots (JPEG images). These screenshots indicate that Intel 
integrated graphics (IGD) VGA passthrough with Xen 4.0.1-RELEASE and 
pv-ops dom0 kernel 2.6.32.21 is successful (albeit the system is very 
unstable).

I have also uninstalled an older version of Xen GPL PV drivers for 
Windows XP and installed gplpv_XP_0.11.0.213_debug.msi.

At the moment, the system is very unstable and Windows XP HVM domU keeps 
crashing with a BSOD after a short while. It also takes at least three 
minutes for Windows XP HVM domU to start booting after the "xm create" 
command is executed. Sometimes, Windows XP HVM domU may not even start 
after the "xm create" command is executed, so I will just have to keep 
rebooting.

I have tried memtest86 scan with 2 passes and the test results indicate 
that there are no hardware memory errors. I have also performed a bad 
sector scan in Windows XP HVM domU and the results are negative.

-- 
Yours sincerely,

Mr. Teo En Ming (Zhang Enming) 张恩鸣 Dip(Mechatronics) 
BEng(Hons)(Mechanical Engineering)
Citizenship: Singapore Citizen/Singaporean
Facebook account: Teo En Ming (Zhang Enming)
Facebook link:http://www.facebook.com/profile.php?id=100000750083982
Facebook 
photos:http://www.facebook.com/profile.php?id=100000750083982#!/profile.php?id=100000750083982&v=photos
Facebook 
videos:http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137
Mobile Phone (Starhub pre-paid): +65-8369-2618
Windows Live Messenger: teoenming-at-hotmail.com
Location: Bedok Reservoir Road, Singapore
ZIP: 470103
My Open Letter (Plea for Medical Help/Assistance) to World Leaders:-
http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007811.html
http://mythtv.org/pipermail/mythtv-users/2010-August/295952.html
http://archives.gentoo.org/gentoo-user/msg_f6a341d9623fda17880159b137c07335.xml
Photo of Mr. Teo En Ming (Zhang Enming) 张恩鸣 of 
Singapore:http://img825.imageshack.us/img825/5052/mrteoenmingzhangenmingo.jpg



On 09/11/2010 11:17 PM, "Mr. Teo En Ming (Zhang Enming) 张恩鸣 of 
Singapore" wrote:
> Dear Pasi, Intel engineers, and Xen developers,
>
> I have just made and uploaded a video to Youtube. The length of the
> video is only 1 minute and 37 seconds. The video demonstrates the
> successful bootup of Windows XP Home Edition HVM domU/virtual machine,
> indicating an initial successful Intel integrated graphics (IGD) VGA
> passthrough, and followed by a BSOD shortly thereafter. The error in
> the BSOD is "/IRQL_NOT_LESS_OR_EQUAL/
> <http://www.google.com.sg/url?sa=t&source=web&cd=2&ved=0CBgQFjAB&url=http%3A%2F%2Fwww.tweaksforgeeks.com%2FIRQL_NOT_LESS_OR_EQUAL.html&ei=VpuLTNGGAoaUvAPH6vQX&usg=AFQjCNHmPolcH-Y1ayBow_q-3Ysd_QIkvw>".
> Full details of the error are in the short video clip.
>
> Please watch my Youtube video at the following link:
>
> http://www.youtube.com/watch?v=xdD25DREx0g
>
> At the time of this writing, there are 24 uploaded videos in my
> Youtube account.
>
> http://www.youtube.com/user/enmingteo
>
> Please let me know what you think after watching the short video clip.
>
> Thank you very much.
>
> --
> Yours sincerely,
>
> Mr. Teo En Ming (Zhang Enming) 张恩鸣 Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
> Citizenship: Singapore Citizen/Singaporean
> Facebook account: Teo En Ming (Zhang Enming)
> Facebook link:http://www.facebook.com/profile.php?id=100000750083982
> Facebook photos:http://www.facebook.com/profile.php?id=100000750083982#!/profile.php?id=100000750083982&v=photos
> Facebook videos:http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137
> Mobile Phone (Starhub pre-paid): +65-8369-2618
> Windows Live Messenger: teoenming-at-hotmail.com
> Location: Bedok Reservoir Road, Singapore
> ZIP: 470103
> My Open Letter (Plea for Medical Help/Assistance) to World Leaders:-
> http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007811.html
> http://mythtv.org/pipermail/mythtv-users/2010-August/295952.html
> http://archives.gentoo.org/gentoo-user/msg_f6a341d9623fda17880159b137c07335.xml
> Photo of Mr. Teo En Ming (Zhang Enming) 张恩鸣 of Singapore:http://img825.imageshack.us/img825/5052/mrteoenmingzhangenmingo.jpg
>
>
>
>
> On 09/11/2010 07:35 PM, "Mr. Teo En Ming (Zhang Enming) 张恩鸣 of
> Singapore" wrote:
>> On 09/11/2010 06:21 PM, Pasi Kärkkäinen wrote:
>>> On Sat, Sep 11, 2010 at 01:57:26PM +0800, "Mr. Teo En Ming (Zhang
>>> Enming) ????????? of Singapore" wrote:
>>>> Dear Intel Engineers,
>>>>
>>>> I am unable to get Intel integrated graphics (IGD) VGA passthrough to
>>>> work with Xen 4.0.1-rc6-pre, Xen 4.0.1-RELEASE, pv-ops dom0 kernel
>>>> 2.6.32.19 and 2.6.32.21. The moment the command "xm create <Windows XP
>>>> HVM guest>" is executed, the screen immediately goes blank with the
>>>> label "NO SIGNAL". It may take anywhere from 3-10 minutes before
>>>> Windows
>>>> XP Home HVM domU starts booting. The HVM guest will subsequently crash
>>>> with a BSOD.
>>>>
>>>> I have posted configuration files, scripts, logs and kernel debug
>>>> messages in threads in the xen-devel mailing list in August 2010 and
>>>> September 2010.
>>>>
>>>> http://lists.xensource.com/archives/html/xen-devel/2010-08/index.html
>>>>
>>>> http://lists.xensource.com/archives/html/xen-devel/2010-09/index.html
>>>>
>>>> Please assist.
>>>>
>>> A couple of questions:
>>>
>>> - I assume the IGD is the primary graphics?
>> Yes, the IGD is the primary display adapter.
>>> - Do you have other graphics adapters in the same machine?
>> Yes, I have NVIDIA GeForce 8400 GS PCI Express x16 graphics card in
>> the same machine.
>>> - Can you please paste "lspci -vvv" from dom0.
>> 00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset
>> Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
>>     Subsystem: Intel Corporation Device 1003
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Interrupt: pin A routed to IRQ 26
>>     Region 0: Memory at d3400000 (64-bit, non-prefetchable) [size=4M]
>>     Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
>>     Region 4: I/O ports at e220 [size=8]
>>     Expansion ROM at <unassigned> [disabled]
>>     Capabilities: <access denied>
>>     Kernel driver in use: i915
>>     Kernel modules: i915
>>
>> 01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400 GS
>> (rev a1) (prog-if 00 [VGA controller])
>>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Interrupt: pin A routed to IRQ 11
>>     Region 0: Memory at d2000000 (32-bit, non-prefetchable)
>> [disabled] [size=16M]
>>     Region 1: Memory at c0000000 (64-bit, prefetchable) [disabled]
>> [size=256M]
>>     Region 3: Memory at d0000000 (64-bit, non-prefetchable)
>> [disabled] [size=32M]
>>     Region 5: I/O ports at d000 [disabled] [size=128]
>>     Expansion ROM at d3000000 [disabled] [size=128K]
>>     Capabilities: <access denied>
>>     Kernel modules: nvidia
>>
>>
>>> - Also paste your grub.conf for the entry you're using for Xen.
>> title Fedora (2.6.32.21-xen-enming.teo)
>>     root (hd0,0)
>>     kernel /xen.gz dom0_mem=1024M
>>     module /vmlinuz-2.6.32.21-xen-enming.teo ro
>> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>>     module /initrd-2.6.32.21-xen-enming.teo.img
>>> -- Pasi
>>>
>>>
>>
>> Thank you very much.
>>
>
>


