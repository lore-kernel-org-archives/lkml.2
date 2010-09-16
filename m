Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0IPGzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:55:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab0IPGy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GvetHNVwqyJZTYJMzcr77EnfDHRf+e/NUZez0++1iBzSDAPJB2xq9bCiUmyTOEtxMm
         Db2bTKkX0g5qcgkCPLRmHV2Qft+yeHiUv9G43jyVQPv9iP7o3Ik8pRDXiCA7X949aMsc
         TendBJR+cmzQpgfoDPnXDdwowN5LVfJ0mrxzE=
MIME-Version: 1.0
In-Reply-To: <20100916062232.GC3393@legolas.emea.dhcp.ti.com>
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
	<20100915105641.GO3393@legolas.emea.dhcp.ti.com>
	<AANLkTi=gYSsxSHqAur+isj_UinVLC-YWkdmi5j_vkSUV@mail.gmail.com>
	<20100915110745.GP3393@legolas.emea.dhcp.ti.com>
	<4C90C5B7.7050103@ru.mvista.com>
	<20100916060520.GA3393@legolas.emea.dhcp.ti.com>
	<AANLkTi=y-HfvDOvhW-WhLFq5TUCjGA-52cuyByCHMvvV@mail.gmail.com>
	<20100916062232.GC3393@legolas.emea.dhcp.ti.com>
Date: Thu, 16 Sep 2010 14:54:57 +0800
Message-ID: <AANLkTi=bk5eEKb3RtzwOk7QCV+EtumvSc=zmXYuzpPFO@mail.gmail.com>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
From: Ming Lei <tom.leiming@gmail.com>
To: balbi@ti.com
Cc: "Gadiyar, Anand" <gadiyar@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/16 Felipe Balbi <balbi@ti.com>:

>> If it's TX, both condtions should automatically be true, right?
>
> even in mode1 ? I have to revist my docs, but afaict mode1 won't
> transmit last short packet, no matter if it's tx or rx. Could be wrong,
> though.

Seems short packet is always sent using mode 0, see txstate.

-- 
Lei Ming
