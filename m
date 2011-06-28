Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab1F1RD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:03:58 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:55512 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758631Ab1F1RCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:02:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ovho7T6nuT/HGxw3qE/2xTUUuSZ40zEgjAhx0Ha9HSnYRtWnfozPiyvuMaDC6ffL46tgOiTdoJEi/fPpRgVkcnlcJdoLbnZQttPUeyrSg6BZjFGM86ZMeBeyEOAbLVtn;
Date: Tue, 28 Jun 2011 10:02:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>, yinghai@kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20110628100227.28f471aa@jbarnes-desktop>
In-Reply-To: <204d042e-86c0-41a5-80f0-e04d6b7adf25@email.android.com>
References: <20110623133740.0cdaf204@jbarnes-desktop>
	<BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
	<20110624085318.70bde05c@jbarnes-desktop>
	<BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com>
	<20110624091148.18f8959d@jbarnes-desktop>
	<204d042e-86c0-41a5-80f0-e04d6b7adf25@email.android.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 15:56:42 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> 
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> >How about a boot param?  We've done similar things for _CRS, and it
> >might give Yinghai and Ram some more flexibility in improving our
> >dynamic resource allocation before enabling it again (if ever).
> 
> I'm OK with that, but then I'd suggest against the currently not yet merged series that doesn't seem to work anyway...
> 
> IOW, just a simple patch that disables the resource re-allocation, and enables it with some command line option.

Ram or Yinghai, want to come up with something?  (And
note: pci=bridge_realloc or something would be a lot more descriptive
than pci=try=2!)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
