Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0IQPyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:54:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60193 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab0IQPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iuoPx711kAHX6ohovIh+sUcMo/agb+VMXLS5gtLr5GTGCFGjQF2bNuGo7o8VOuJLvl
         LLEvHDqAR2MyX2T9K/vbK/FH0eRaxzvQ52vMCbwEBmnOr5ddzJitkEtH+s2u/TLjuV6/
         T7QEElQQTCZUR1XL25rACvVLHdgfa5BglufeE=
MIME-Version: 1.0
Date: Fri, 17 Sep 2010 23:54:32 +0800
Message-ID: <AANLkTikrgooRh3tv+TCE-dNbwENcAss4EUnr4T4=Mgi6@mail.gmail.com>
Subject: What is happening to my harddisk?
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been getting endless stream in dmesg like the following:

[  602.800594] ata7.00: status: { DRDY ERR }
[  602.816578] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  602.816584] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  602.816596] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  602.816597]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  602.816601] ata7.00: status: { DRDY ERR }
[  602.836572] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  602.836578] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  602.836589] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  602.836590]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  602.836594] ata7.00: status: { DRDY ERR }
[  602.852579] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  602.852584] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  602.852596] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  602.852597]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  602.852600] ata7.00: status: { DRDY ERR }
[  602.868585] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  602.868590] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  602.868601] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  602.868602]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  602.868606] ata7.00: status: { DRDY ERR }
[  602.884586] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  602.884592] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  602.884607] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  602.884608]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  602.884613] ata7.00: status: { DRDY ERR }
[  602.900614] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  602.900620] sr 6:0:0:0: CDB: Get event status notification: 4a 01
00 00 10 00 00 00 08 00
[  602.900633] ata7.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio 16392 in
[  602.900635]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  602.900638] ata7.00: status: { DRDY ERR }
[  602.900664] sr0: CDROM (ioctl) error, command: Get event status
notification 4a 01 00 00 10 00 00 00 08 00
[  602.900673] sr: Sense Key : Aborted Command [current] [descriptor]
[  602.900677] sr: Add. Sense: No additional sense information
[  603.800595] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  603.800600] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  603.800612] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  603.800613]          res 51/04:00:00:69:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  603.800617] ata7.00: status: { DRDY ERR }
[  603.816587] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  603.816592] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  603.816603] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  603.816604]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  603.816608] ata7.00: status: { DRDY ERR }
[  603.832576] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  603.832583] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  603.832594] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  603.832595]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  603.832598] ata7.00: status: { DRDY ERR }
[  603.848574] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  603.848580] sr 6:0:0:0: CDB: Get event status notification: 4a 01
00 00 10 00 00 00 08 00
[  603.848594] ata7.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio 16392 in
[  603.848595]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  603.848598] ata7.00: status: { DRDY ERR }
[  603.848623] sr0: CDROM (ioctl) error, command: Get event status
notification 4a 01 00 00 10 00 00 00 08 00
[  603.848632] sr: Sense Key : Aborted Command [current] [descriptor]
[  603.848636] sr: Add. Sense: No additional sense information
[  604.797852] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.797859] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.797871] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.797872]          res 51/04:00:00:69:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.797875] ata7.00: status: { DRDY ERR }
[  604.812577] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.812583] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.812594] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.812595]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.812599] ata7.00: status: { DRDY ERR }
[  604.828570] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.828576] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.828587] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.828588]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.828592] ata7.00: status: { DRDY ERR }
[  604.848581] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.848587] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.848598] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.848599]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.848603] ata7.00: status: { DRDY ERR }
[  604.864859] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.864865] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.864876] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.864877]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.864881] ata7.00: status: { DRDY ERR }
[  604.880571] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.880576] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.880588] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.880589]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.880592] ata7.00: status: { DRDY ERR }
[  604.899138] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.899145] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.899156] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.899158]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.899161] ata7.00: status: { DRDY ERR }
[  604.912584] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.912590] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.912602] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.912604]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.912607] ata7.00: status: { DRDY ERR }
[  604.930032] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.930038] sr 6:0:0:0: CDB: Get event status notification: 4a 01
00 00 10 00 00 00 08 00
[  604.930052] ata7.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio 16392 in
[  604.930053]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.930057] ata7.00: status: { DRDY ERR }
[  604.930137] sr0: CDROM (ioctl) error, command: Get event status
notification 4a 01 00 00 10 00 00 00 08 00
[  604.930147] sr: Sense Key : Aborted Command [current] [descriptor]
[  604.930151] sr: Add. Sense: No additional sense information
[  604.944597] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.944603] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  604.944615] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  604.944616]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.944619] ata7.00: status: { DRDY ERR }
[  604.960570] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  604.960578] sr 6:0:0:0: CDB: Get event status notification: 4a 01
00 00 10 00 00 00 08 00
[  604.960591] ata7.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio 16392 in
[  604.960593]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  604.960596] ata7.00: status: { DRDY ERR }
[  604.960623] sr0: CDROM (ioctl) error, command: Get event status
notification 4a 01 00 00 10 00 00 00 08 00
[  604.960632] sr: Sense Key : Aborted Command [current] [descriptor]
[  604.960637] sr: Add. Sense: No additional sense information
[  605.976600] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  605.976607] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  605.976621] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  605.976623]          res 51/04:00:00:69:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  605.976627] ata7.00: status: { DRDY ERR }
[  605.992584] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  605.992591] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  605.992606] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  605.992607]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  605.992612] ata7.00: status: { DRDY ERR }
[  606.008586] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  606.008593] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  606.008604] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  606.008605]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  606.008609] ata7.00: status: { DRDY ERR }
[  606.024594] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  606.024602] sr 6:0:0:0: CDB: Get event status notification: 4a 01
00 00 10 00 00 00 08 00
[  606.024620] ata7.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio 16392 in
[  606.024622]          res 51/04:00:00:41:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  606.024626] ata7.00: status: { DRDY ERR }
[  606.024719] sr0: CDROM (ioctl) error, command: Get event status
notification 4a 01 00 00 10 00 00 00 08 00
[  606.024732] sr: Sense Key : Aborted Command [current] [descriptor]
[  606.024738] sr: Add. Sense: No additional sense information
[  606.802020] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  606.802027] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  606.802042] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  606.802044]          res 51/04:00:00:69:00/00:00:00:00:00/00 Emask
0x1 (device error)
[  606.802048] ata7.00: status: { DRDY ERR }
[  636.988650] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  636.988657] sr 6:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[  636.988672] ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  636.988674]          res 40/00:00:00:69:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  636.988678] ata7.00: status: { DRDY }
[  637.044522] ata7: soft resetting link
[  637.208572] ata7.01: NODEV after polling detection
[  637.224622] ata7.00: both IDENTIFYs aborted, assuming NODEV
[  637.224627] ata7.00: revalidation failed (errno=-2)
[  642.200531] ata7: soft resetting link
[  642.372669] ata7.00: both IDENTIFYs aborted, assuming NODEV
[  642.372674] ata7.00: revalidation failed (errno=-2)
[  647.356538] ata7: soft resetting link
[  647.528577] ata7.00: both IDENTIFYs aborted, assuming NODEV
[  647.528582] ata7.00: revalidation failed (errno=-2)
[  647.528587] ata7.00: disabled


Ignoring those related to CD (sr devices), can someone please explain
to me what is happening, and what device does ata7 mapped to?

Thank you very much.

-- 
Regards,
Peter Teoh
