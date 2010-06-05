Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0FESuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 14:50:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53482 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0FESuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 14:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=TQT//rfPi7XNbK0cstGQP+tbJIwqs/vzqWdt1OdIPC/J2TxUvJDoCIiUVfYj/v6P8N
         kgwAoNtI0KFhrW4eX1ePfZx35jul28viEG11TooxRovxKgkc/HqC3j4n3SgvuLUrVuSz
         2l7Owqm+aiGFK5PaHsFaj7OUR4CLA8C4R7ESI=
MIME-Version: 1.0
In-Reply-To: <AANLkTimTq_Bf-hJ7DmRT8bo7zwDKo2rfm8zhGvMckJz7@mail.gmail.com>
References: <AANLkTimTq_Bf-hJ7DmRT8bo7zwDKo2rfm8zhGvMckJz7@mail.gmail.com>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Sat, 5 Jun 2010 20:50:14 +0200
Message-ID: <AANLkTileh4jCV5ILSUcEpcQ0ZZvKqXyOCKwpIhEhkEgG@mail.gmail.com>
Subject: iptables slows tproxy SQUID with DNAT or REDIRECT
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello guys
i am having very strange problem with my SQUID and iptables.
It is for sure NOT A SQUID ISSUE (i've tested 6 different versions of
squid, 2.7.x , 3.0.x and 3.1.x - and  other people dont have this
issue)
In all versions there was one problem. When i use TRANSPARENCY mode
(so i redirect 80 port in iptables via DNAT or REDIRECT)
      iptables -t nat -A PREROUTING -p tcp -s 192.168.0.2 ! -d
192.168.0.0/24 --dport 80 -j REDIRECT --to-port 8123 # Tytanick
      iptables -t nat -A PREROUTING -p tcp -s 192.168.0.2 ! -d
192.168.0.0/24 --dport 80 -j DNAT --to 192.168.0.1:8123 # Tytanick
i am having problem that pages load SLOWLY - exacly few images load very slowly.
In all cases, my browser cache and squid cache was cleaned.
Just watch a movie that i made and you will see my problem clearly !

You can download zipped html and swf(movie) file from rapidshare: (you
can choose different resolutions)
http://rapidshare.com/files/395636925/iptables_squid_slow_1600.rar
http://rapidshare.com/files/395636761/iptables_squid_slow_1440.rar
http://rapidshare.com/files/395634867/iptables_squid_slow_1024.rar
http://rapidshare.com/files/395632385/iptables_squid_slow_800.rar

OR if you cant download from rapidshare, here are direct links to my
server (with SLOW UPLOAD 50 KB/s - so you will need to wait few mins
:P)
http://sky-link.net/temp/squid/squid_problem/iptables_squid_slow_1600.html
http://sky-link.net/temp/squid/squid_problem/iptables_squid_slow_1440.html
http://sky-link.net/temp/squid/squid_problem/iptables_squid_slow_1024.html
http://sky-link.net/temp/squid/squid_problem/iptables_squid_slow_800.html

my kernel version: linux-2.6.34
iptables: 1.4.3.2
Linux Gentoo
3GHZ core2duo
4GB RAM


--
Z pozdrowieniami
Tytus Rogalewski
mail: tytanick{monkey}gmail.com
www.sky-link.net
gg: 210533
skype: tytanick
