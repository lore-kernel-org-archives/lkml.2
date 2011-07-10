Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1GJQi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:38:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49018 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1GJQi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110710032510.GG6014@linux.vnet.ibm.com>
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
	<201107072047.14429.kernelmail.jms@gmail.com>
	<20110707195845.GD6014@linux.vnet.ibm.com>
	<201107072147.12751.kernelmail.jms@gmail.com>
	<20110708002903.GI6014@linux.vnet.ibm.com>
	<20110709100900.GB6014@linux.vnet.ibm.com>
	<CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
	<20110710032510.GG6014@linux.vnet.ibm.com>
Date: Sun, 10 Jul 2011 17:38:25 +0100
Message-ID: <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I added another patch onto the jms.2011.07.07a in the -rcu git tree.
> If you get a chance to test it, please let me know how it goes.
>
>                                                        Thanx, Paul


Right, adding this commit to the other six:

commit 8a153670878242b8a95213d986f4922111321743

 makes us freeze on boot again.

Cheers
Julie
