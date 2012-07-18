Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2GRPpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:45:20 -0400
Received: from mail.stepping-stone.ch ([194.176.109.206]:52371 "EHLO
	mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2GRPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:45:19 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2012 11:45:18 EDT
Message-ID: <5006D810.8090408@stepping-stone.ch>
Date: Wed, 18 Jul 2012 17:36:48 +0200
From: stepping stone GmbH <support@stepping-stone.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel crash with lspci -vv and SAS Controller LSI Logic / Symbios
 Logic MegaRAID SAS 9240
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks

While trying to list Informations about the PCI Devices using lspci -vv 
the Output stops at the SAS Controller (LSI Logic / Symbios Logic 
MegaRAID SAS 9240 rev03) (probably just before the "Kernel driver in 
use" Line) and the system completly freezes. Listing the PCI Devices 
with only lspci -v works though.

Vanilla Kernel: Linux version 3.4.4 (gcc version 4.5.3 (Gentoo 4.5.3-r1 
p1.0, pie-0.4.5) ) #1 SMP Mon Jul 16 13:13:04 CEST 2012

ASUS RS700-E6-ERS4 rev. 1.xxG with ASUS Mainboard Z8PS-D12-1U with two 
Xeon E5645 2.40GHz and 12 x 8GB DIMM

AMI BIOS Version: 1201


Informations about the Controller

  ~# MegaCli -AdpAllInfo -aALL
  
Adapter#0
  
==============================================================================
                     Versions
                 ================
Product Name    : LSI MegaRAID ROMB
Serial No       :
FW Package Build:20.9.1-0011
  
                     Mfg. Data
                 ================
Mfg. Date       :00/00/00
Rework Date     :00/00/00
Revision No     :
Battery FRU     : N/A
  
                 Image Versionsin  Flash:
                 ================
BIOS Version       :4.18.00_4.09.05.00_0x0416A000
Preboot CLI Version:03.02-012:#%00008
WebBIOS Version    :4.0-42-e_30-Rel
NVDATA Version     :3.08.03-0006
FW Version         :2.110.04-0967
Boot Block Version :2.01.00.00-0019
  
                 Pending Imagesin  Flash
                 ================
None
  
                 PCI Info
                 ================
Vendor Id       :1000
Device Id       :0073
SubVendorId     :1043
SubDeviceId     : 843b
  
Host Interface  : PCIE
  
Number of Frontend Port:0  
Device Interface  : PCIE
  
Number of Backend Port:8  
Port  :  Address
0         5000c50042e37119
1         5000c50042e31e5d
2         4433221102000000  
3         4433221103000000  
4         0000000000000000  
5         0000000000000000  
6         0000000000000000  
7         0000000000000000  

a tail of lspci -vv http://pastebin.com/kjh8ig9q

continued at http://pastebin.com/fWv2uX5p

/proc/cpuinfo /proc/ioports and /proc/iomem at http://pastebin.com/pdRi2BJD


Greetings

David Vollmer

-- 
stepping stone GmbH
Neufeldstrasse 9
CH-3012 Bern

Telefon: +41 31 332 53 63
www.stepping-stone.ch
support@stepping-stone.ch

