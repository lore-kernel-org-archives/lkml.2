Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0KRJRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:17:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58152 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0KRJRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KitM0+XmJPMD7CLrKTyWOsZMaWK4olE1fgwjEkfwXT4VxaCh8Fjjdgb2xWEH2M4iPJ
         0vDjnxKLnNex7nnntV3sMw1iGh3xoob8jfQDbByZ3CvPh/VjvjymvjS3ufuTn9EmbMaz
         51GQf762oJws95P6MOlhx29UKV5jgwPfWba1Y=
Subject: Re: 2.6.37-rc2 after KVM shutdown - unregister_netdevice: waiting
 for vmtst01eth0 to become free. Usage count = 1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: KVM list <kvm@vger.kernel.org>, netdev list <netdev@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz,
        Linux kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20101118062822.GB3781@pcnci.linuxbox.cz>
References: <20101116084148.GA3781@pcnci.linuxbox.cz>
	 <1289900812.5372.1.camel@edumazet-laptop>
	 <20101118062822.GB3781@pcnci.linuxbox.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 10:16:53 +0100
Message-ID: <1290071813.2781.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 novembre 2010 à 07:28 +0100, Nikola Ciprich a écrit :
> > Yep, this is a known problem, thanks !
> > 
> > fix is there : 
> > 
> > http://patchwork.ozlabs.org/patch/71354/
> Thanks Eric, this indeed fixes the problem..
> I noticed the fix didn't make it to 2.6.37-rc2-git3 though,
> maybe it just got omited?
> anyways, thanks for help!
> n.

Its in David Miller net-2.6 tree (all pending network patches for
current linux-2.6 version), so it'll be included next time David push
its tree to Linus, dont worry ;)



