Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0GIH10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:27:26 -0400
Received: from mx01.bfk.de ([193.227.124.2]:47107 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0GIH1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:27:25 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 03:27:24 EDT
To: "Loke\, Chetan" <Chetan.Loke@netscout.com>
Cc: "Matt Domsch" <Matt_Domsch@dell.com>,
       "Michael Di Domenico" <mdidomenico4@gmail.com>,
       <linux-net@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: nic enumeration
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
	<20100708012120.GB11419@auslistsprd01.us.dell.com>
	<D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 09 Jul 2010 07:18:25 +0000
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com> (Chetan Loke's message of "Thu\, 8 Jul 2010 16\:36\:18 -0400")
Message-ID: <82tyo9i0n2.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chetan Loke:

>> And on a system where you can use udev rules, the
>> 70-persistent-net.rules file can be used to make them constant, by
>> using the MAC address to force the names to be what you want.
>> 
>
> Ok, but can we achieve the renaming w/o a reboot? 

"udev-trigger" or "udevadm trigger" works for renaming network
interfaces.  The kernel has some restrictions on renaming interfaces
which are in use, so this might not work in your case.

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
