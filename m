Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1DKOfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:35:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58547 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1DKOfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ig/zWrvNcPQD5tF45jgd9GQTbiHtKvxvC5zh6HLhhrVqiHHxtg20H64DXzSsWYkDqj
         dLyQ+z7GVeGP9EogmSBAe1UlJvJBDJBLZQghWV2heKkEdxediqtmykrldvZjLCXXQ09t
         oIQbmvOpkPikfNodBh3Hk2qWfsxoxybwIKZC0=
MIME-Version: 1.0
In-Reply-To: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 11 Apr 2011 16:35:29 +0200
Message-ID: <BANLkTi=_iOpAUUwuiq4-e-82a4W_8KET9w@mail.gmail.com>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, xose.vazquez@gmail.com, ben@decadent.org.uk,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Shiang Tu <shiang_tu@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 4:27 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Shiang Tu <shiang_tu@ralinktech.com>
>
> Update firmware for rt2800pci to Version 34 and firmware for rt2800usb to
> Version 29.
>
> Signed-off-by: Shiang Tu <shiang_tu@ralinktech.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  WHENCE     |    8 ++++----
>  rt2860.bin |  Bin 8192 -> 8192 bytes
>  rt2870.bin |  Bin 4096 -> 8192 bytes
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/WHENCE b/WHENCE
> index 6632b85..44da621 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1068,13 +1068,13 @@ Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
>
>  --------------------------------------------------------------------------
>
> -Driver: rt2860sta - Ralink RT2860, RT2890 wireless MACs
> +Driver: rt2800pci - Ralink RT2860, RT2890, RT3090, RT5390 wireless MACs
>
>  File: rt2860.bin
>
>  Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
>
> -Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
> +Binary file supplied by Shiang Tu <shiang_tu@ralinktech.com>. Firmware Version 34
>
>  --------------------------------------------------------------------------
>
> @@ -1088,7 +1088,7 @@ Found in hex form in kernel source.
>
>  --------------------------------------------------------------------------
>
> -Driver: rt2870sta - Ralink RT2870, RT3070, RT3071, RT3072 wireless MACs
> +Driver: rt2800usb - Ralink RT2870, RT3070, RT3071, RT3072, RT5370 wireless MACs
>
>  File: rt2870.bin
>  File: rt3070.bin
> @@ -1096,7 +1096,7 @@ File: rt3071.bin
>
>  Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
>
> -Found in hex form in kernel source.
> +Binary file supplied by Shiang Tu <shiang_tu@ralinktech.com>. Firmware Version 29
>
>  --------------------------------------------------------------------------
>
> diff --git a/rt2860.bin b/rt2860.bin
> index 778a771716aff389c79fec3b245ed00beba23a67..85030fc2d9d91295f647e6d40557c65b6859d2b7 100644
> GIT binary patch
> literal 8192
> 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
> VZNqD%YNXaVWJTBi<)8Sn@(+{BrhNba
>
> literal 8192
> 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
>
> diff --git a/rt2870.bin b/rt2870.bin
> index d94fc7ee072c17a532eac1d3287eab130d09fd91..f1535d1eced0844d0aba9e65d188f769624c9fa4 100644
> GIT binary patch
> literal 8192
> zcmeHLeQXrR6~CR`JI*%7dwXC0xTDABjKLIp`A7mTIF3Jwu{nd+J`=vSmeqs+>O$@k
> zr48KH!T&^2Ssa??kD?^@AFYrgOUNQpD}`!7QKeK(by21KQ)w_aiIj+Vo3K)v24COo
> zo$Dj94YWzqs6OfD<IS75Z{ECl^X8Y$W)Z&z@f#6;68RDGv&b(Ze~sY3Pehf6QPm45
> za0&VUCOKV^QdS5Z7j@<ZEM1R~0SWV@OTt{LNkb`z&eu<yFqUwe8J+nxZDI+BbVkFI
> z$UlxJ8D3{j<H?^DQ6|O|O8+40oDWAnfG;w-DqyQ$=Qu1BpXWc=z`y-~hwt%p?Dq8R
> z@$~e1dSuVpJ`e5}8dc%&ap9LIygQ%tstMm?n(uktcloTtL1lQbwJoEoUK0c-G?Vn-
> zRH<;}`#geJi4C7b6a7NT+1#kjSimyU|8N?Ky2@iYmAzbCO2tjOUCCWcGIn~Fj08#^
> zaw{C3jKCP1j72h54NUXkXm+#%mc-#|96eyg>6C1uqdNZCThnjR@oZv8u9La7h#I70
> zXqgg*(yaucEK)pB7AqxCmMBirF}d7Lg~?@B19Xbqq+ya}GgdovifM<To%|QloUPc+
> zEY;-@lpfqy6VugllQwm=!pt*DelG3PR>KIkYIL*~18)VMnLY?@Q|jO*YBY}2fE=`D
> zy3njt?hKW6>&9pATk*x#RlsTu|NJ?82X5X092slC+N<*{o?PQh4lvp_yDdQ*X_DRE
> z1Z_@>+U@(7>pa4fCxGPEJULRaO?r_{4)EZx*D7?U8@Dp%E#2wF@;}U0&b%Sd0MX1?
> zyR2BUA)DNmeLbGr9(8kKgE^j9Z5n}$wcmQw+NZ0MIc^%k`5lO^5PaapMYmUnh3WkF
> zO*k%zCVLy?loiLarmGvF3ob+A@4nL1tgD+yJV$^g2GVi5DI0N2cREZmAeSjzDhLP9
> zqdS>tP?IqeteF)`e@oeYrgrs960W?`Q-2Q<I9md!b9dh?SXFA)sS2!QA1km;XWBVy
> zUHgR2o<ZdqP0gDxK;6mOe;XUvojhuelYOvF_BME_6DqCR4=6Lp4bsWhf!iiYL2rSv
> zv20rLwgV8GAUx2?%XGDxx`HT@UbRwEiY|6b-JG-C;7F`(m*OTde@sRGU7~0-zbi^U
> ziJpkQ8n8z>j@|i?7(OYW7!x|rfgi)M!Lrkell?=Cx{AbsDq$COK#jxTgCs6ZZE)@*
> z`_y&LN3|O0;wrKqxYPnBd%Oh3mr<cGD?K6VeCUQbPPe}pJSv2(0i9ooBiBBKkuW8f
> z+)kbt5RIKi7ionk8}K>;uW^C%?!ZYtP!kDsD1m`j9ge{G$c~ng&gPM>gAj6D3X1~c
> zS{2!G6(UXx>7-RN>7tcAuKuvMrA*sD@<_|b&gPNs9IYEBJd&HRGdH1oZh}Nw<g!-Y
> zYSC812RJ*XIbAIWxny$@1ThzHk4rG_O7GNAx+`N<ljf_knWY0U>rh$|(|*zswUm<R
> z+sd+Nlj<`3qENY62)t+bjR}JT%Yf<Oa*<akT)JFylU;2waFg=1O&!aORwP!M<Pa=k
> zJ*if`Qn`~HijWeiq5_Cg_Oj#wvNKt|Ttoiq^wIP&t&AL!-gg<a$)%4P$3S&fT_x?z
> zk;;LcmAX7&T6^BI*?BZX`$%i#dI@P5La<hd)*O{W!?l-&>zn|H+^Q`%a(Edz7{Tb`
> z<B=n@bq!s7B65tjrqIQs$-1V<VQ%bkZMF2ci?okTX<^FEr5JhzlXlshdDG-hLGP5~
> z;~&F{pBz0AIl_%S0TZ5>n{aL63CYn!<QO-0)ZUz8Rg{j>Y1g%&t*hPKOxhzERwC@X
> z8gm5%+Z;JfrWO`_d{mt~jx4@%PHL*aLmL&}*zwV)$JEiMNS)U!KV;PzPp6-ff~CE6
> zCaG&X0CCdPTu>6|gFmVr^e{;sY*s@zvuEtfN}e%E3pkihSstB%KdX9;Em~Q6i&jF~
> zr72s_(JfMkbD{=S*3o;6R`i}NgVL>l+rd4{qKaS5Bl`=JH24(Jr&Rlt_0cbsN1}gM
> ze9;wZ4{4|RCQbG<F{4?nA-xqo+L-@f_=;9Zo2Bv=SZR;zlmoVigVOOab;K>kR?R!7
> z8=c7+KrFawb1E*kl`8?|DmTre+$~$Vh)-GNQ`UiUZJ?Y0%5@ehr>#wI)fx)ErmbH@
> zwXNXl|1#QE4c(>`s4#7c;JYO}%@X8~Oj09%)Yb+WP-Zq&XoFOtEuSigXL{0m#WQkx
> zK+IT!#st~zQ+D{2A4L(Ys7g)mP4+Q58iS0>9EVKsKAqbP*<uK?MHHlkkctSEhiJT$
> zKQ)uP8JI(QR9AA4&ejD7mRU8=L#12>9+cw&h9f!}$I|=IdQ9gY#6zO`jLtltI0dQc
> zOQtSxG-i6&KpIpD^;)Q_pk4>HXwzjAbb^A?<UhidD_!@JZ8vpqtpd5jryAs75WjtS
> zk{ipPv~8pDT>c!=PX^1k%;X@G>_ZuAw^jsNJ3(t}HyKp?1_Lx>@9TpTO+sip8JuKM
> znzdt=#0Zc)zhu&3gMoC_X4nIc&4Ix}4aq$qk)`5WSI{J&Tv-X~V^{{H3RO_Ag_!Sz
> zwg~NYCS*adz}7NYNUne(ST}1gCIE><VhZ@(@VB#v6eE<@((P#dJzN`b$1I2Yc8}F3
> zp&|pFWF{U4Z6y{NtgRy`JbhDHpP5Pc>a5|+X4QHQPi8CTdedeiG&^#`6j!{-{Y4ZZ
> z6R5?~wQh*dD%hS6fwEwGJ`8m&)GKor)?oe~qn8>m0x=BrTBuh-U2966aDPYX{cSiw
> z5m9t3{gy1SWPy9LK-k!lz3u(K3Hdjp0D}T9A%H|wwF8BYpx`f1;LrK@f4JxCd;kA+
> z?)|^9@cn;@|8N8Urw2UV9#7|PPwyU2Z?C6U_MGeUT<;ei9ukhJ!pp~nw@!GUebW0{
> z!uPV~`<?DHDFgsw=7#__BLBKV2;f4&+awPGP?rBT1h9Y_c53qVKmZr+76Q2N??3?5
> zX7<agHo2WmHhwQ-)#sjI3oMNCei<&fGixDSun_mR4i{X|7lI3{+W7#3S<^u>m<J3N
> zS=u)W7`*cz0|vH)djbsJnR^P<CuRYILIZpSFen_P&-VoYgFM^40S5U=cMljewry96
> zNu$3}E%tBMTsh|_lnQX;6se`C<5c3+>Ux?NbwOUF{3LZs2)r>Z&$Oajw0WM?rySLQ
> zutgo#aH6|$Vp#9`4SmUHtbQw=N&zzv@aN;WI&KYrcz?h3+_dS8lemhU{a4Our2ib#
> z^j=PAE1MHp@WG7ftS9x8ZomTT|3Bf4OMy=uL5&MO>kjVcgRV$$wGw>rRfi)u{AG9}
> zIQ*S}H>$is@Qo#SV+r0^6yB&Rwc!n@z6x(t{&XG$;ah_@Y!&C=jVfUt<-XJKMksby
> z@J3Z*0lX24&B7a@SOL5NJah1d%>!US=PbMtYX9GbH^QMiz#G6Y3vYxgzIk|K$D;5?
> UIJ5+B+}jIsiTk^3f$(YLpLS|iMgRZ+
>
> delta 1096
> zcmXX^&2Jk;6yKd)f5maVJL}j)#>wJtNfXrILQ9h%C5`QRlh{r3v5AC`(rsm>6am__
> zwLnO*2Z04bi8S$4oQi~!1L8ssvBVKb`VSBe96O>}dH~Utz=uMJncd{@e(%kj_j?~R
> z4_!v;aJ$_G(pezA0;CTByanJ}0DcPK8ib#vL3|P<dV%sjfa@8bUyTSb@nahEYc%sX
> zxiP9=g3H)~w6%yuk;0BIrSHy5bVe3u<;a{InU^DmJiQ=SE%}=j`IkE|br+5zj)Th^
> zPkIL7GJx0Xi{twsjV*~9wK6aT;3kx5IcNrHS@q79X`ymWC6n?6@*xi|dNf-v2h1?T
> zpy{*qW+>>AjA(1bJJ=&lK{#j?4*uI-gyD^SF-=Cni$0G@Zi9Zwv#<nc)9Trx%?$Yy
> zq{)gH7m6rLib6^>2ha=TmZ*|}t}qdOr)%lm;%>>#vk~Dor({KCG^lh-a8HGgP5Ad$
> z9H->#6S?|Swq9CdZTVT}N**QciHEGKoIT~LtX*=IcW*7v=c4FFeKJ=sX6sjveRGU3
> zc}yrC6Rw^Ry32m+qMb9Md8w5{FR>{_|NPRwm28N7?9ZIXR^HjNmzYd3nP5_4;`*{o
> za?ZY)wslj|ey{`>?}y47`N{vaA6o_coI`M+hnc!-ejA9B>0pvPV)|hqNu*#0$h<>-
> z51dg}8Wxr~ilvtwED3b)e&#ayDA-kF4tvmXN482B^i$)=v2(2Jm>JWK%+s2{ULyV+
> z24`tTkD`EUsJfp;F>juC(Jo|u6>B^KHO{>?j;?uL_lKk24~H0ryfg=`KCi~1V~@nl
> zb1`$U7BgSd4$bS@GqYDaW!<(5ieija9O08~N7cnDOIzihzNfX(l}#OuyS0R$QQscY
> zTr*+}u|a11RgTpc8FGxX$~dds(|4z}c4KH$-)Rh^?h_ur*BEv^Lnz>>#&EaS^5K;}
> z2U`#95%$_Tv&NZ4COQUcg_wC$bJsc{?7vZ2;4#=_i|%Yu^+_6w7ibeC+5UmJ3vx|`
> z@i8ok)cDJ(%<|~2J!APQHwE-Ih8#5n>m<U>@jZ(GXqH6)RKS2G{OxrtUZUl+^(y8+
> zzgKlI|AmvnP`uaSV1+%a!>S&`KModoYCI!vhR=Y+I=S(DZz8d7&&AA;Xq75+d}Tp!
> pBl4#l@+h1ja%WdKybD(O?Qxh`M>}%r53oZ!Qv!oKK<K<b_CEn4lxhF~
>
> --
> 1.7.3.4
>
>



-- 
---
Gertjan
