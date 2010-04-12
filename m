Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0DLLML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:12:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41449 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0DLLMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a4pP/CpO+MxDxuVWBVib+/FVd52H2hyRIpuSxYSgusJBihdHLAxgZibCX7CV2v95yW
         3fZXrs6omxtj4HVuk4yG7ah6cctu4x7rL9H5AlE/bnuhHQj8ufZF5WZhH1lMcBSbfbky
         Ofp62W6uiq7KVVh6EaU/APIHzsEVnysnuBt8w=
Date: Mon, 12 Apr 2010 13:14:33 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33.2 does not boot on Atom?
Message-ID: <20100412111433.GA6631@linux-m68k.org>
References: <20100406205509.GA12034@linux-m68k.org> <20100412061604.GB31112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412061604.GB31112@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 11:16:05PM -0700, Greg KH wrote:
> On Tue, Apr 06, 2010 at 10:55:09PM +0200, Richard Zidlicky wrote:
> > Hi,
> > 
> > I have been compiling my own kernels since ages and switched from 2.6.32.8 to 
> > 2.6.33.2 now.
> > Same procedure like allways - copied .config to new buildtree, make menuconfig
> > (almost nothing changed in config), installed the new kernel on 2 machines.
> 
> Oops, that's the problem, you need to do 'make oldconfig' to ensure you
> didn't miss anything, and to adjust any new defaults.

did not tried that yet. Although it is possible to miss something with menuconfig
I did diff the .config files without noticing anything obvious.

Meanwhile I have tried a few recent Fedora-12 kernels and none of them worked on 
this particular Atom Netbook with which I have never had problems before.
With the Fedora kernels the issue appears to be Intel graphics and it seems the boot
continued when I blindly typed the dm password.. so I will investigate further.
Last Fedora kernel that worked was 2.6.31 based, the 2.6.32.* I tried so far will
display a black screen.

Richard
