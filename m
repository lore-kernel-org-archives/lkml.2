Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0LMTE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:04:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54967 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0LMTE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e22M45EOPcm5lJDwX8JYaAAjoFG4Ko62iUkAjX+nKT87t4FGi16Lamf9Oo1gr1mDl5
         JmxLgi6V4gVVCN3gQqI5wcfuKdQIvW83wK9moGSekZB4a5G2x3ycBky0yZtJHIZerWWM
         202jkMEB2yfBeWl6gZvrv16fOxcgdx2IaY7O8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinXT6jyr9C=LJA9Y_5v3sWN1fDHF9NRsTLHVXuF@mail.gmail.com>
References: <20101210135746.0cf6cbcd.sfr@canb.auug.org.au>
	<AANLkTinXT6jyr9C=LJA9Y_5v3sWN1fDHF9NRsTLHVXuF@mail.gmail.com>
Date: Mon, 13 Dec 2010 20:04:26 +0100
Message-ID: <AANLkTikSjXT6xxKyamvE8YEygfpakdDMFt2F1rnkytfN@mail.gmail.com>
Subject: Re: linux-next: Tree for December 10
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this should be reported for next-20101213

W dniu 13 grudnia 2010 20:02 u¿ytkownik Zimny Lech
<napohybelskurwysynom2010@gmail.com> napisa³:
> Ave,
>
> 2010/12/10 Stephen Rothwell <sfr@canb.auug.org.au>:
>> Hi all,
>>
>> Changes since 20101209:
>>
>
> WARNING: modpost: Found 14 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>  GEN     .version
>  CHK     include/generated/compile.h
>  UPD     include/generated/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
> arch/x86/built-in.o: In function `kvm_smp_prepare_boot_cpu':
> kvm.c:(.init.text+0xf446): undefined reference to `kvm_register_clock'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x1087ee): undefined reference to `__alloc_skb'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x108897): undefined reference to `skb_put'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x108930): undefined reference to `kfree_skb'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x108947): undefined reference to `nla_reserve'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x108990): undefined reference to `kfree_skb'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x1089e9): undefined reference to `kfree_skb'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x1089f8): undefined reference to `init_net'
> drivers/built-in.o: In function `generate_netlink_event':
> (.text+0x108a0b): undefined reference to `netlink_broadcast'
> drivers/built-in.o: In function `thermal_init':
> thermal_sys.c:(.init.text+0xbd00): undefined reference to `genl_register_family'
> thermal_sys.c:(.init.text+0xbd2f): undefined reference to
> `genl_register_mc_group'
> thermal_sys.c:(.init.text+0xbd57): undefined reference to
> `genl_unregister_family'
> drivers/built-in.o: In function `thermal_exit':
> thermal_sys.c:(.exit.text+0x154c): undefined reference to
> `genl_unregister_family'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
>
>
> --
> Slawa!
> Zimny "Spie dziadu!" Lech z Wawelu
>
> Hej, tam!
> Wydar³em klejnot szans
> http://www.youtube.com/watch?v=VXWTlYzVFUA
>



-- 
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

Hej, tam!
Wydar³em klejnot szans
http://www.youtube.com/watch?v=VXWTlYzVFUA
