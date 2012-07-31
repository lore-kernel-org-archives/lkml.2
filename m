Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2GaMGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:06:19 -0400
Received: from mail.profihost.ag ([85.158.179.208]:43154 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:06:14 -0400
Message-ID: <5017C8A0.60506@profihost.ag>
Date: Tue, 31 Jul 2012 13:59:28 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: avi@redhat.com
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: KVM segfaults with 3.5 while installing ubuntu 12.04
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

i hope it is correct to list the maintainers of kvm. While trying to 
install ubuntu 12.04 amd64 on a kvm based vm the KVM process segfaults 
while ubuntu tries to detect the HW:
kvm[2978]: segfault at 7fb90d9035e0 ip 00007fb90d9035e0 
sp00007fff652e4ed8 error 15

This does not happen with a rhel6 based 2.6.32 kernel so i thought this 
must be a bug in vanilla 3.5.0 kernel.

Is this known? What information do you need?

Thanks!

Greets
Stefan
