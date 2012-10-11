Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab2JKRo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:44:57 -0400
Received: from nm9-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.196]:48094 "EHLO
	nm9-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964838Ab2JKRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:44:55 -0400
X-Yahoo-Newman-Id: 418997.18235.bm@smtp141.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1fIaeYwVM1lGWeLUOStRF7KY1arOfvOZT6vVycoYwgnKSu_
 RTgM8.e_NOwjTfB6YDP4JlGnVGLYvJmshUP1pH_SZMNlF2L__24zbBSc._aq
 OmpoYeHT7oklqnNvBxqrMOoiFMIL2NrAp.KiOnxGJhEksL3OJhSmEaxaiDGY
 TomXRgL6OOEq9ov0OosuFQrdRyJsaEmcH6voGPhXv4Q10eZdNpTTykfgGUI8
 sirYItXQGeDiEhcYMNHI9LTG4Y9yzyWOrwkjhWhJoZzSBdqT_58yZFljLSqd
 jo14KHsPkPV7lG8TtINBfe6ja8BedxH4y_XsOio1G3zm4n8tsJ90CTX38LKt
 4Y2afxwM8GDUr1eAfnTQzA0F.FeV_DeKG3oVxXKaJJsFYSmosBKT8qeYeOPM
 ATP18DeGvgZWUidmfk1jpexK8ljXsy3.1RL3ID4LeUu7C5AdW5QF7E3SjYmw
 0duwL3lU5NkwAl15LJcXF9rnFy.Z6_oP5LPggBZ2jP2_8aNMEr8tKULe_PWo
 MZ8PUC5I7_JVj_G5apDpQ6nCrj4cikxKqLjZ4VZ.CWea6BgPTHPU-
X-Yahoo-SMTP: Ll_2CwGswBCmYyy8D5vkxPEWV_RIV9L47w--
Date: Thu, 11 Oct 2012 13:44:51 -0400
From: William Park <opengeometry@yahoo.ca>
To: linux-kernel@vger.kernel.org
Subject: rt2800pci + 3.6.x = not working (Linksys WMP600N)
Message-ID: <20121011174451.GA7914@node1.opengeometry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, just a report...

I have Linksys WMP600N (dual-band) wireless card,

    06:05.0 Network controller [0280]: RaLink RT2800 802.11n PCI [1814:0601]
	    Subsystem: Linksys Device [1737:0067]
	    Kernel driver in use: rt2800pci
	    Kernel modules: rt2800pci

It is working in 3.5.x but not in 3.6.x.  It doesn't connect and get IP (dhcp)
from the router.  Also, this wireless card works reliably only in 3.5.x.
Previous versions tend to drop connections.
-- 
William
