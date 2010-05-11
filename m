Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0EKSOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:14:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab0EKSOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:14:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] cpumask: fix compat getaffinity
Date: Tue, 11 May 2010 20:13:55 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Ken Werner <ken.werner@web.de>, Andi Kleen <andi@firstfloor.org>,
       stable@kernel.org
References: <20100511104334.E572.A69D9226@jp.fujitsu.com> <20100511151526.E578.A69D9226@jp.fujitsu.com> <20100511152002.GB16561@kroah.com>
In-Reply-To: <20100511152002.GB16561@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005112013.56392.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX181s4Y0xUObTN8YunEgWBn0TMRZHuLugl1GJdL
 Kxpp0sB46hKHQVIHBWktYfphjf2W49Hhbi2MN3r264yowX2Krt
 KAAf2LeMgmYBd25bimTWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 May 2010 17:20:02 Greg KH wrote:
> > AFAIK, -stable is mainly used for distro and they have many and many
> > packages. we can't assume no app read /sys files directly.
> > IOW, To change /sys printing format is a bit risky change. frequently
> > compatibility breaking natually break code stability.
> 
> Ah, the sysfs user/kernel API is what you are referring to here, right?
> If so, remember, any changes need to be documented in Documentation/API
> :)
> And as for distros using -stable for their releases, that's fine, they
> well know the risks/benefits for that and handle changes on their own.

Would it make sense to use my initial patch for -stable, which reverts
the ABI back to before the change that caused the problem, but apply
the correct fix (changing the ABI throughout) for future releases?

	Arnd
