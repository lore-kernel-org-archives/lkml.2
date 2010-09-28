Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0I1FZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 01:25:43 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2244 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab0I1FZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 01:25:42 -0400
Message-ID: <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Mike Frysinger" <vapier@gentoo.org>
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Alek Du" <alek.du@intel.com>, <richard.rojfors@mocean-labs.com>,
        <meego-dev@meego.com>,
        "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        "Qi" <qi.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <gregkh@suse.de>, "Yong Y" <yong.y.wang@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>, <margie.foster@intel.com>,
        <kok.howg.ewe@intel.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main> <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org> <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com> <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Date: Tue, 28 Sep 2010 14:25:36 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> find out what range of GPIO numbers your driver is using and use those
> instead of "1"
I have attached a part of our source file.

Since I set "ngpio=12",
I guess 0-11 can be used, thus, "echo 1 > export" should be success too.
Is this true ?

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Mike Frysinger" <vapier@gentoo.org>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>; "Andrew Morton" <akpm@linux-foundation.org>; "Samuel Ortiz"
<sameo@linux.intel.com>; "Randy Dunlap" <randy.dunlap@oracle.com>; "Alek Du" <alek.du@intel.com>;
<richard.rojfors@mocean-labs.com>; <meego-dev@meego.com>; "ML linux-kernel" <linux-kernel@vger.kernel.org>; "Qi"
<qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <gregkh@suse.de>; "Yong Y" <yong.y.wang@intel.com>; "Tomoya
MORINAGA" <morinaga526@dsn.okisemi.com>; <joel.clark@intel.com>; <margie.foster@intel.com>; <kok.howg.ewe@intel.com>
Sent: Tuesday, September 28, 2010 2:02 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35


On Tue, Sep 28, 2010 at 00:57, Masayuki Ohtake wrote:
> I have modified for GPIO standard I/F referring other accepted GPIO driver.

no idea what this driver is

> According to Documentation/gpio.txt,
> I tried to create GPIO node like below.
>
> [root@localhost gpio]# ls
> export gpiochip244 unexport
> [root@localhost gpio]# echo 1 > export
> bash: echo: write error: Invalid argument
> [root@localhost gpio]#
>
> But it fails.

find out what range of GPIO numbers your driver is using and use those
instead of "1"
-mike


begin 666 pch_gpio.c
M<W1A=&EC('9O:60@<&-H7V=P:6]?<V5T=7 H<W1R=6-T('!C:%]G<&EO7V-H
M:7 @*F-H:7 I#0I[#0H)<W1R=6-T(&=P:6]?8VAI<" J9W!I;R ]("9C:&EP
M+3YG<&EO.PT*#0H)9W!I;RT^;&%B96P@/2!D979?;F%M92AC:&EP+3YD978I
M.PT*"6=P:6\M/F]W;F5R(#T@5$A)4U]-3T153$4[#0H)9W!I;RT^9&ER96-T
M:6]N7VEN<'5T(#T@<&-H7V=P:6]?9&ER96-T:6]N7VEN<'5T.PT*"6=P:6\M
M/F=E=" ]('!C:%]G<&EO7V=E=#L-"@EG<&EO+3YD:7)E8W1I;VY?;W5T<'5T
M(#T@<&-H7V=P:6]?9&ER96-T:6]N7V]U='!U=#L-"@EG<&EO+3YS970@/2!P
M8VA?9W!I;U]S970[#0H)9W!I;RT^9&)G7W-H;W<@/2!.54Q,.PT*"6=P:6\M
M/F)A<V4@/2 H=3,R*6-H:7 M/G!C:%]G<&EO7V)A<V5?861D<F5S<SL-"@EG
M<&EO+3YN9W!I;R ](#$R.PT*"6=P:6\M/F-A;E]S;&5E<" ](# [#0I]#0H-
M"@T*<W1A=&EC(',S,B!?7V1E=FEN:70@<&-H7V=P:6]?<')O8F4H<W1R=6-T
M('!C:5]D978@*G!D978L#0H)"0D)(" @(&-O;G-T('-T<G5C="!P8VE?9&5V
M:6-E7VED("II9"D-"GL-"@ES,S(@<F5T.PT*"7-T<G5C="!P8VA?9W!I;U]C
M:&EP("IC:&EP.PT*#0H)8VAI<" ](&MZ86QL;V,H<VEZ96]F*'-T<G5C="!P
M8VA?9W!I;U]C:&EP*2P@1T907TM%4DY%3"D[#0H):68@*&-H:7 @/3T@3E5,
M3"D-"@D)<F5T=7)N("U%3D]-14T[#0H-"@EC:&EP+3YD978@/2 F<&1E=BT^
M9&5V.PT*#0H)<F5T(#T@<&-I7V5N86)L95]D979I8V4H<&1E=BD[#0H):68@
M*')E="D@>PT*"0ED979?97)R*"9P9&5V+3YD978L("(E<R Z('!C:5]E;F%B
M;&5?9&5V:6-E($9!24Q%1"(L(%]?9G5N8U]?*3L-"@D)9V]T;R!E<G)?<&-I
M7V5N86)L93L-"@E]#0H-"@ER970@/2!P8VE?<F5Q=65S=%]R96=I;VYS*'!D
M978L($U/1%5,15].04U%*3L-"@EI9B H<F5T*2![#0H)"61E=E]E<G(H)G!D
M978M/F1E=BP@(B5S(#H@<&-I7W)E<75E<W1?<F5G:6]N<R!&04E,140B+ T*
M"0D)"0D)"0E?7V9U;F-?7RD[#0H)"6=O=&\@97)R7W)E<75E<W1?<F5G:6]N
M<SL-"@E]#0H-"@EC:&EP+3YP8VA?9W!I;U]B87-E7V%D9')E<W,@/2!P8VE?
M:6]M87 H<&1E=BP@,2P@,"D[#0H-"@EI9B H8VAI<"T^<&-H7V=P:6]?8F%S
M95]A9&1R97-S(#T](# I('L-"@D)9&5V7V5R<B@F<&1E=BT^9&5V+" B)7,@
M.B!P8VE?:6]M87 @1D%)3$5$(BP@7U]F=6YC7U\I.PT*"0ER970@/2 M14Y/
M345-.PT*"0EG;W1O(&5R<E]I;VUA<#L-"@E]#0H)8VAI<"T^<F5G(#T@8VAI
M<"T^<&-H7V=P:6]?8F%S95]A9&1R97-S.PT*#0H)<&-I7W-E=%]D<G9D871A
M*'!D978L(&-H:7 I.PT*"7!C:%]G<&EO7V-B7W)E9VES=&5R*'!C:%]G<&EO
M7V-B+"!C:&EP*3L-"@EC:&EP+3YP8VA?9W!I;U]I<G$@/2!P9&5V+3YI<G$[
M#0H)9&5V:6-E7W-E=%]W86ME=7!?96YA8FQE*"9P9&5V+3YD978L(#$I.PT*
M#0H)<&-H7V=P:6]?<V5T=7 H8VAI<"D[#0H)<F5T(#T@9W!I;V-H:7!?861D
M*"9C:&EP+3YG<&EO*3L-"@EI9B H<F5T*2![#0H)"7!R:6YT:RA+15).7T52
M4B B4$-((&=P:6\Z($9A:6QE9"!T;R!R96=I<W1E<B!'4$E/7&XB*3L-"@D)
M9V]T;R!E<G)?9W!I;V-H:7!?861D.PT*"7T-"@T*"7)E='5R;B P.PT*#0IE
M<G)?9W!I;V-H:7!?861D.@T*"7!C:5]I;W5N;6%P*'!D978L(&-H:7 M/G!C
M:%]G<&EO7V)A<V5?861D<F5S<RD[#0H-"F5R<E]I;VUA<#H-"@EP8VE?<F5L
M96%S95]R96=I;VYS*'!D978I.PT*#0IE<G)?<F5Q=65S=%]R96=I;VYS.@T*
M"7!C:5]D:7-A8FQE7V1E=FEC92AP9&5V*3L-"@T*97)R7W!C:5]E;F%B;&4Z
D#0H):V9R964H8VAI<"D[#0H)<F5T=7)N(')E=#L-"GT-"@T*
`
end

