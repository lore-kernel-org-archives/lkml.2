Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab1CDKGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:06:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54567 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1CDKGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pUPee5fpCUVpd85PoC70qLXY2hbBtrviLHIoyBOhDJB+RdK03SFnfkk79EJloxN0rN
         q4dHABTJVQOHJQ4c5x7vgD/P3Bxr/Ko1VpP/Dq5B6DFmCSwHO0hpjNW5GZXQoaGe8x+z
         UuyZxWDmF0hv9UOhPK9bVJdFenN26f33ayX7E=
MIME-Version: 1.0
In-Reply-To: <AANLkTinXWz7rtsaw9qRjkqAr+d4g3MnmPFQYzZe9ZR2Q@mail.gmail.com>
References: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
	<20110303135942.GA8969@tuxdriver.com>
	<AANLkTinXWz7rtsaw9qRjkqAr+d4g3MnmPFQYzZe9ZR2Q@mail.gmail.com>
Date: Fri, 4 Mar 2011 15:36:20 +0530
Message-ID: <AANLkTi=4z8=3Qz25DhO=Z2VhAsKR-xZtK2oEPdjjLimH@mail.gmail.com>
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath9k-devel@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 6:25 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Thu, Mar 3, 2011 at 5:59 AM, John W. Linville <linville@tuxdriver.com> wrote:
>> On Wed, Mar 02, 2011 at 09:47:43PM -0800, Justin Mattock wrote:
>>> not sure what this is..(below)
>>>
>>>
>>> [   33.951046] CE: hpet increased min_delta_ns to 20113 nsec
>>> [   35.567319] EXT4-fs (sda3): re-mounted. Opts:
>>> errors=panic,user_xattr,debug,acl,commit=600
>>> [   36.350144] wlan0: authenticate with 00:0b:86:32:f8:60 (try 1)
>>> [   36.352284] wlan0: authenticated
>>> [   36.352396] wlan0: associate with 00:0b:86:32:f8:60 (try 1)
>>> [   36.356854] wlan0: RX AssocResp from 00:0b:86:32:f8:60 (capab=0x421
>>> status=0 aid=2)
>>> [   36.356862] wlan0: associated
>>> [   41.370318] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x42000020
>>> [   41.370324] ath: Could not stop RX, we could be confusing the DMA
>>> engine when we start RX up
>>> [   41.370328] ------------[ cut here ]------------
>>> [   41.370345] WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
>>> ath_stoprecv+0xc8/0xda [ath9k]()
>>> [   41.370349] Hardware name: MacBookPro2,2
>>> [   41.370351] Modules linked in: hidp xfrm4_mode_transport xcbc
>>> rmd160 sha512_generic rfcomm sco bnep l2cap ipt_REJECT xt_tcpudp
>>> ipt_LOG iptable_nat nf_nat xt_state nf_conntrack_ftp nf_conntrack_ipv4
>>> nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables btusb
>>> bluetooth evdev psmouse thermal fan container button ac battery video
>>> ath9k ath9k_common ath9k_hw ath ttm drm aes_x86_64 lzo zlib ipcomp
>>> xfrm_ipcomp crypto_null sha256_generic cbc des_generic cast5 blowfish
>>> serpent camellia twofish_generic twofish_x86_64 twofish_common ctr ah4
>>> esp4 authenc firewire_ohci firewire_core uhci_hcd ehci_hcd coretemp
>>> acpi_cpufreq processor mperf appletouch applesmc
>>> [   41.370430] Pid: 766, comm: kworker/u:4 Not tainted
>>> 2.6.38-rc6-00116-g2821f46 #5
>>> [   41.370434] Call Trace:
>>> [   41.370444]  [<ffffffff810612c0>] ? warn_slowpath_common+0x80/0x98
>>> [   41.370450]  [<ffffffff810612ed>] ? warn_slowpath_null+0x15/0x17
>>> [   41.370458]  [<ffffffffa01c6438>] ? ath_stoprecv+0xc8/0xda [ath9k]
>>> [   41.370467]  [<ffffffffa01c3a62>] ? ath_set_channel+0xb0/0x217 [ath9k]
>>> [   41.370475]  [<ffffffffa01c3f89>] ? ath9k_config+0x3c0/0x4c3 [ath9k]
>>> [   41.370482]  [<ffffffff8140fe8a>] ? ieee80211_hw_config+0x120/0x129
>>> [   41.370487]  [<ffffffff81413902>] ? ieee80211_scan_work+0x2f8/0x496
>>> [   41.370495]  [<ffffffffa01c7934>] ?
>>> ath_tx_complete_poll_work+0xf3/0x102 [ath9k]
>>> [   41.370501]  [<ffffffff8141360a>] ? ieee80211_scan_work+0x0/0x496
>>> [   41.370506]  [<ffffffff810769c7>] ? process_one_work+0x266/0x3d7
>>> [   41.370511]  [<ffffffff81076e9f>] ? worker_thread+0x1d6/0x350
>>> [   41.370515]  [<ffffffff81076cc9>] ? worker_thread+0x0/0x350
>>> [   41.370521]  [<ffffffff8107bdcf>] ? kthread+0x7d/0x85
>>> [   41.370528]  [<ffffffff8102e064>] ? kernel_thread_helper+0x4/0x10
>>> [   41.370533]  [<ffffffff8107bd52>] ? kthread+0x0/0x85
>>> [   41.370537]  [<ffffffff8102e060>] ? kernel_thread_helper+0x0/0x10
>>> [   41.370541] ---[ end trace 062f507148a6fa8e ]---
>>>
>>>
>>> from what I remember I was at a local college(caltech) trying to
>>> connect to their public wifi
>>> in the public area. with no luck, then this popped up.
>>> full dmesg here:
>>>
>>> http://fpaste.org/SKU4/
>>
>> In ath_stoprecv:
>>
>>        if (!(ah->ah_flags & AH_UNPLUGGED) &&
>>            unlikely(!stopped)) {
>>                ath_err(ath9k_hw_common(sc->sc_ah),
>>                        "Could not stop RX, we could be "
>>                        "confusing the DMA engine when we start RX up\n");
>>                ATH_DBG_WARN_ON_ONCE(!stopped);
>>        }
>>
>> The Atheros guys will have to comment.
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>>
>
> cool, thanks for the reply.
> yeah this is strange, seems to have happened in that location and not others.
> (if I have time wouldn't mind testing out other kernel versions and
> maybe a bisect to
> grab this)

Hi,
Can you please try the obvious way of increasing the timeout for
stopping the DMA  ?
in mac.c

148 #define ATH9K_TX_STOP_DMA_TIMEOUT       4000    /* usec */
increase it to 10000 usec

and
781#define AH_RX_STOP_DMA_TIMEOUT 10000   /* usec */
increase it to 20,000 usec
>
> --
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
