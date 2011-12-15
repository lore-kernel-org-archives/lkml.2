Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1LOIdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:33:42 -0500
Received: from diyaorg.dp.ua ([82.207.88.73]:56607 "EHLO diyaorg.dp.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab1LOIdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:33:40 -0500
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Dec 2011 03:33:40 EST
Message-ID: <4EE9AE64.6040401@diyaorg.dp.ua>
Date: Thu, 15 Dec 2011 10:23:00 +0200
From: Roman Savochenko <rom_as@diyaorg.dp.ua>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111209 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: No new network interface UP in driver cdc_ether
Content-Type: multipart/mixed;
 boundary="------------070602000905040509020902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070602000905040509020902
Content-Type: text/plain; charset=KOI8-U; format=flowed
Content-Transfer-Encoding: 7bit

Hello, All

On kernel version 2.6.39 and more I see problem with network "cdc_ether" 
driver.
On plug mobile phone, in my case the Nokia N800, N900 and N950, driver 
register new interface usb0 but do not UP it.
By that reason user side network managers like NetworkManager do not see 
that interface and ordinary user do not allowed for control it.
Sure I can call "ifconfig usb0 up" but for that need superuser access.

For observe the problem I had seen to "cdc_ether" source from 2.6.38 to 
2.6.39 version and no any significant changes placed here.
I think the problem by generic network subsystem changes.

Regards, Roman

--------------070602000905040509020902
Content-Type: text/x-vcard; charset=utf-8;
 name="rom_as.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rom_as.vcf"

begin:vcard
fn:Roman Savochenko
n:Savochenko;Roman
org:DIYA Ltd
adr:;;;Dneprodzerzinsk;Dnepropetrovsk;51925;Ukraine
email;internet:rom_as@diyaorg.dp.ua
title:Leading engineer-programer
tel;work:+380675675542
tel;fax:+380569262025
tel;home:+380569292458
tel;cell:+380679859815
url:http://diyaorg.dp.ua
version:2.1
end:vcard


--------------070602000905040509020902--
