Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IOLOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:14:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55638 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0IOLOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JmeRT6PBRfYf9+1bFql3urwb3dWfiOB+RHA8fzx+rWZHsQJyoJN2OWUDQyEl34QPQI
         0BxWdGzSRDl9B3R6P2q85mbUtIay0jXp+PqkAtaxGk0r+GSMZP6E8FhbDocTjskIsYo5
         IBgdaxmS5IcipylwxkyvybSLx7vL3XzMPeVqo=
MIME-Version: 1.0
In-Reply-To: <20100915105641.GO3393@legolas.emea.dhcp.ti.com>
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
	<20100915105641.GO3393@legolas.emea.dhcp.ti.com>
Date: Wed, 15 Sep 2010 19:14:41 +0800
Message-ID: <AANLkTi=m0UTDnX9HFAuEPrm_7hbZW=CzeV=juXrj+wiC@mail.gmail.com>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
From: Ming Lei <tom.leiming@gmail.com>
To: balbi@ti.com
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/15 Felipe Balbi <balbi@ti.com>:

>
>> IMO, it is not difficult to give a good fix for the ZLP problem
>> if the two questions are clear.
>
> true, but some re-work needs to be done.

I suggest we do the fix for ZLP issue in a new patch against the
current patch set to avoid the rework. More importantly, it is one
another fix, we should insist on the rule: do one fix in one commit,
which is very helpful to do version management(regression test,
bisect...).

-- 
Lei Ming
