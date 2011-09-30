Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab1I3Wuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:50:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1I3Wug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:50:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ZcNJcTQLg+m4h/l5FDpjBTiCiZgto9OaV26QBRGz6sX0vZQoal01NpWH5XSn6gaPB
	6Z6OrSbYadxEWWaI8sLGg==
MIME-Version: 1.0
In-Reply-To: <CAMaF-rMrwZHzoZyfXCDem_68m3=mSpq=LAQC006aZ471wWQN9w@mail.gmail.com>
References: <20110928220225.GA27128@kroah.com> <20110928220135.776796691@clark.kroah.org>
 <CAErSpo5ynWTUNSY7NuXC-bRx5ZT0J-Ya5iTg=MBCSH37PYMS+A@mail.gmail.com> <CAMaF-rMrwZHzoZyfXCDem_68m3=mSpq=LAQC006aZ471wWQN9w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Sep 2011 16:50:13 -0600
Message-ID: <CAErSpo4verd83gYjZY18L4DhKYkHryx-c8zrGjCTWEutEnEnqw@mail.gmail.com>
Subject: Re: [099/244] PCI: Set PCI-E Max Payload Size on fabric
To: Jon Mason <mason@myri.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 4:40 PM, Jon Mason <mason@myri.com> wrote:
>
> On Fri, Sep 30, 2011 at 5:33 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Sep 28, 2011 at 4:01 PM, Greg KH <gregkh@suse.de> wrote:
> >> 3.0-stable review patch.  If anyone has any objections, please let us know.
> >
> > I object to this :)  I think the following patches should be omitted
> > from -stable:
> >
> > [099/244] PCI: Set PCI-E Max Payload Size on fabric
> > [100/244] PCI: export pcie_bus_configure_settings symbol
> > [101/244] PCI: Remove MRRS modification from MPS setting code
> > [212/244] pci: Dont crash when reading mpss from root complex
> >
> > I've heard rumors that these patches are required to make 3.0 boot on
> > some machines, but I don't really believe it, and I haven't seen the
> > problem reports myself.
>
> Would it be acceptable to disable MPS modification by default (as you
> have been suggesting for 3.1) and have the machines who are having the
> boot issues pass a boot parm to enable the MPS modification?

I'm OK with 3.1 having MPS modification disabled by default, but
having a command line switch to enable it.

Should that same thing go in 3.0-stable?  I dunno.  My first reaction
is "No, because I still don't have a concrete problem report that says
it fixes anything."  I can't tell if these are secret machines, people
thinking the 3.1-rcX regressions are a problem in 3.0, or what.

Bjorn
