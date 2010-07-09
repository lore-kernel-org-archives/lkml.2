Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0GIINe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:13:34 -0400
Received: from mx01.bfk.de ([193.227.124.2]:42584 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0GIINc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:13:32 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Loke\, Chetan" <Chetan.Loke@netscout.com>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: nic enumeration
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
	<20100708012120.GB11419@auslistsprd01.us.dell.com>
	<D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
	<82tyo9i0n2.fsf@mid.bfk.de>
	<AANLkTilRdnjShlB2JA1TjxMklTjw4ASl3BhwUWtKRdMW@mail.gmail.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 09 Jul 2010 08:13:18 +0000
In-Reply-To: <AANLkTilRdnjShlB2JA1TjxMklTjw4ASl3BhwUWtKRdMW@mail.gmail.com> (Kay Sievers's message of "Fri\, 9 Jul 2010 09\:57\:14 +0200")
Message-ID: <827hl5hy3l.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kay Sievers:

> Anyway, it's not recommended to do anything like this. On many distros
> it will cause trouble with the network scripts/services, which are run
> again for already active interfaces. Using the udevadm trigger
> 'hammer' on the running system may lead to all sorts of problems. This
> tool is usually only used at coldplug time during bootup.

There was a time when the Debian scripts were pretty robust.  But
maybe we've just been lucky.

> In general, there is no safe way, or a tool to do this. You have to
> know very well what you are doing. It's pretty common, that you
> disconnect yourself from a remote box if you try anything like this.

Yeah, but there should be a way to do this over OOB management,
without requiring a reboot. 8-(

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
