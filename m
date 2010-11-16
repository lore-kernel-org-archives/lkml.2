Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab0KPJq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:46:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49347 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab0KPJq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UgIMLJhPAnj5MmZyKm0AcVl6HyHqbIGWSUWHcxujlImAJeHuJB4ST4H/sf3xnO+/m7
         QmYOEvBktCkvaD9w6cOH2OOXIirsZi0miXdIFBG2fNsFSsG2gn/zd+Aewadln3OGH0Mf
         RtkRfo0FnEYJUwa1HdIaL3M85f19Pfe+DdSvs=
Subject: Re: 2.6.37-rc2 after KVM shutdown - unregister_netdevice: waiting
 for vmtst01eth0 to become free. Usage count = 1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: KVM list <kvm@vger.kernel.org>, netdev list <netdev@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz,
        Linux kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20101116084148.GA3781@pcnci.linuxbox.cz>
References: <20101116084148.GA3781@pcnci.linuxbox.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 10:46:52 +0100
Message-ID: <1289900812.5372.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 16 novembre 2010 à 09:41 +0100, Nikola Ciprich a écrit :
> Hello,
> I just tried running KVM on 2.6.37-rc2 host, and when trying to shutdown guest, it
> got to unterruptible state (D) and I'm getting lots of following messages:
> [ 1269.392009] unregister_netdevice: waiting for vmtst01eth0 to become free. Usage count = 1
> So I just want to report..
> n.
> 
> 

Yep, this is a known problem, thanks !

fix is there : 

http://patchwork.ozlabs.org/patch/71354/



