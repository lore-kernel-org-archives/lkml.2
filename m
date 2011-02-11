Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1BKIZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:25:06 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:47595 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1BKIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:25:05 -0500
Date: Fri, 11 Feb 2011 09:24:55 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: linux-kernel@vger.kernel.org, bskeggs@redhat.com
Subject: [REGRESSION? 2.6.38-rc4] nouveau NV50 screen freeze
Message-ID: <20110211082455.GA16802@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I don't know if I suffer a regression of nouveau in 2.6.38-rc4.

It feels like the screens tends to freeze often in that version but I cannot be
sure if it is the 2.6.38-rc4 release or something else.

The current 2.6.37 kernel has this in Xorg.0.log:

[    71.783] (II) AutoAddDevices is off - not adding device.
[    78.808] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[    78.808] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    78.808] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[    78.808] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[    79.422] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[    79.422] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    79.423] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[    79.423] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[    80.115] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[    80.115] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    80.115] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[    80.115] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[    80.729] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[    80.729] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    80.729] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[    80.729] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[   507.789] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[   507.789] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[   507.789] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[   507.789] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[   567.978] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[   567.978] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[   567.978] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[   567.978] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)

The current 2.6.38-rc4 kernel has this in Xorg.0.log:

[    75.466] (II) AutoAddDevices is off - not adding device.
[    89.585] (II) AIGLX: Suspending AIGLX clients for VT switch
[    89.585] (II) NOUVEAU(0): NVLeaveVT is called.
[    97.577] (II) Open ACPI successful (/var/run/acpid.socket)
[    97.578] (II) AIGLX: Resuming AIGLX clients after VT switch
[    97.578] (II) NOUVEAU(0): NVEnterVT is called.
[    97.691] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[    97.691] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    97.691] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[    97.691] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[    98.322] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[   957.921] (II) 3rd Button detected: disabling emulate3Button
[  2852.323] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2852.323] (II) NOUVEAU(0): NVLeaveVT is called.
[  2855.850] (II) Open ACPI successful (/var/run/acpid.socket)
[  2855.850] (II) AIGLX: Resuming AIGLX clients after VT switch
[  2855.850] (II) NOUVEAU(0): NVEnterVT is called.
[  2855.966] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  2855.966] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  2855.966] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  2855.966] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  2856.597] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  2863.361] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2863.361] (II) NOUVEAU(0): NVLeaveVT is called.
[  2879.447] (II) Open ACPI successful (/var/run/acpid.socket)
[  2879.447] (II) AIGLX: Resuming AIGLX clients after VT switch
[  2879.447] (II) NOUVEAU(0): NVEnterVT is called.
[  2879.561] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  2879.561] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  2879.561] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  2879.561] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  2880.192] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  2884.543] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2884.543] (II) NOUVEAU(0): NVLeaveVT is called.
[  2890.337] (II) Open ACPI successful (/var/run/acpid.socket)
[  2890.337] (II) AIGLX: Resuming AIGLX clients after VT switch
[  2890.337] (II) NOUVEAU(0): NVEnterVT is called.
[  2890.451] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  2890.451] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  2890.451] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  2890.451] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  2891.081] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  2895.780] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2895.780] (II) NOUVEAU(0): NVLeaveVT is called.
[  2917.475] (II) Open ACPI successful (/var/run/acpid.socket)
[  2917.475] (II) AIGLX: Resuming AIGLX clients after VT switch
[  2917.475] (II) NOUVEAU(0): NVEnterVT is called.
[  2917.588] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  2917.588] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  2917.588] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  2917.588] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  2918.219] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  2921.735] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2921.735] (II) NOUVEAU(0): NVLeaveVT is called.
[  2988.993] (II) Open ACPI successful (/var/run/acpid.socket)
[  2988.993] (II) AIGLX: Resuming AIGLX clients after VT switch
[  2988.993] (II) NOUVEAU(0): NVEnterVT is called.
[  2989.107] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  2989.107] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  2989.107] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  2989.107] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  2989.738] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  2997.111] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2997.111] (II) NOUVEAU(0): NVLeaveVT is called.
[  2997.952] (II) Open ACPI successful (/var/run/acpid.socket)
[  2997.952] (II) AIGLX: Resuming AIGLX clients after VT switch
[  2997.952] (II) NOUVEAU(0): NVEnterVT is called.
[  2998.065] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  2998.065] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  2998.065] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  2998.065] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  2998.700] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  2999.201] (II) AIGLX: Suspending AIGLX clients for VT switch
[  2999.201] (II) NOUVEAU(0): NVLeaveVT is called.
[  3045.403] (II) Open ACPI successful (/var/run/acpid.socket)
[  3045.404] (II) AIGLX: Resuming AIGLX clients after VT switch
[  3045.404] (II) NOUVEAU(0): NVEnterVT is called.
[  3045.519] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  3045.519] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  3045.519] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  3045.519] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  3046.151] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  3118.308] (II) AIGLX: Suspending AIGLX clients for VT switch
[  3118.308] (II) NOUVEAU(0): NVLeaveVT is called.
[  3119.091] (II) Open ACPI successful (/var/run/acpid.socket)
[  3119.091] (II) AIGLX: Resuming AIGLX clients after VT switch
[  3119.091] (II) NOUVEAU(0): NVEnterVT is called.
[  3119.204] (II) NOUVEAU(0): EDID vendor "LEN", prod id 16561
[  3119.204] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[  3119.204] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 1930  900 903 906 912 -hsync -vsync (54.9 kHz)
[  3119.204] (II) NOUVEAU(0): Modeline "1600x900"x0.0  106.00  1600 1664 1706 2324  900 903 906 912 -hsync -vsync (45.6 kHz)
[  3119.838] (II) Configured Mouse: ps2EnableDataReporting: succeeded
[  3120.522] (II) AIGLX: Suspending AIGLX clients for VT switch
[  3120.522] (II) NOUVEAU(0): NVLeaveVT is called.
[  3125.951] (II) UnloadModule: "mouse"
[  3125.951] (II) UnloadModule: "kbd"
[  3125.961] (II) NOUVEAU(0): Closed GPU channel 2
[  3125.976] (WW) xf86CloseConsole: VT_WAITACTIVE failed: Interrupted system call

but I don't know if it's related to the screen freeze. Does anyone experience
the similar behavior?

Regards,
Marc

-- 
Marc Koschewski
