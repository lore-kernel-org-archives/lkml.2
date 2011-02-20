Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1BTOEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 09:04:07 -0500
Received: from smtp.witbe.net ([81.88.96.48]:37692 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1BTOEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 09:04:04 -0500
Date: Sun, 20 Feb 2011 15:03:38 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: Linux 2.6.38-rc5
Message-ID: <20110220150338.760597e0@tux.DEF.witbe.net>
In-Reply-To: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dAFzvEw5c7EvTgfIHox7sxj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dAFzvEw5c7EvTgfIHox7sxj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 15 Feb 2011 20:16:01 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Chris Wilson (7):
...
>       drm/i915: Fix resume regression from 5d1d0cc

Not sure if what I have is the same or not, but starting with -rc4, when
resuming from suspend, the video stays on the framebuffer output it
switches too when suspending, and the X graphical content is not restored.

Nothing is then updated on the screen, making the machine unusable after
resume (well, I could try to ssh to the box, but it is a laptop, not a
server, so X's pretty mandatory).

[root@tux ~]# lspci
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Contr=
oller Hub (rev 07)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipse=
t Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integ=
rated Graphics Controller (rev 07)
...

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipse=
t Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
        Subsystem: Dell Device 02bc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at f6800000 (64-bit, non-prefetchable) [size=3D4M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
        Region 4: I/O ports at 1800 [size=3D8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
                Address: fee0100c  Data: 4189
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Kernel driver in use: i915


00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integ=
rated Graphics Controller (rev 07)
        Subsystem: Dell Device 02bc
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at f6100000 (64-bit, non-prefetchable) [size=3D1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #4 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Dell Device 02bc
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at 1820 [size=3D32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

If there is any other info I can provide, please feel free to ask.=20
If you have any patch to test, please feel free to send.

Best,
Paul


--Sig_/dAFzvEw5c7EvTgfIHox7sxj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk1hHz4ACgkQZP464AVDf+D92ACfVd9+CXsRvNuNpQOZIJFwg4Xw
fK8An3M/X5D4oedXCtATkCVXs2Umt50g
=3Qjs
-----END PGP SIGNATURE-----

--Sig_/dAFzvEw5c7EvTgfIHox7sxj--
