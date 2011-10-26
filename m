Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1JZWL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 18:11:57 -0400
Received: from smtpauth05.prod.mesa1.secureserver.net ([64.202.165.99]:33866
	"HELO smtpauth05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752641Ab1JZWL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 18:11:56 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 18:11:56 EDT
From: J LaCroix <j@jlacroix.me>
To: linux-kernel@vger.kernel.org
Subject: Battery Sometimes Not Detected
Date: Wed, 26 Oct 2011 18:05:33 -0400
Message-ID: <4499333.9RBPNNDCzX@athena>
User-Agent: KMail/4.7.2 (Linux/3.0-ARCH; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to submit this bug to the Kernel Bugzilla, but it appears to be 
down. 

Anyway, I'm on kernel 3.0, using 64-bit Arch Linux on a Dell Latitude 
E6410. Every now and then, the battery shows up as though it's not 
connected, even while running on it. This is seemingly random, and if it 
happens, I just reboot my laptop and it will see the battery fine most of 
the time. I want to say about one in ten boots it doesn't see the 
battery on average. I filed this first against KDE, but then the problem 
happened in XCE so it's not a KDE issue. Then, I filed it against upower 
but they told me this is a kernel bug.

An interesting point to note is that while this problem happens whether 
I am using my docking station or not, if I undock my laptop while the 
laptop doesn't see the battery, all of a sudden the battery is 
recognized.

Running "ls /sys/class/power_supply/"  while suffering from this bug gives 
me:
AC


upower -d reports:
Device: /org/freedesktop/UPower/devices/line_power_AC
  native-path:          
/sys/devices/LNXSYSTM:00/device:00/ACPI0003:00/power_supply/AC
  power supply:         yes
  updated:              Wed Oct 26 17:04:34 2011 (3127 seconds ago)
  has history:          no
  has statistics:       no
  line-power
    online:             yes

Daemon:
  daemon-version:  0.9.14
  can-suspend:     yes
  can-hibernate    yes
  on-battery:      no
  on-low-battery:  no
  lid-is-closed:   no
  lid-is-present:  yes
  is-docked:       no

-- 
J LaCroix
A+, Network+, Server+, Linux+, CLA, DCTS, LPIC-1 Certified
Field Technician
(P) 248.520.4062
(E) j@jlacroix.me
http://www.jlacroix.me 
