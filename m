Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0KIN2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:28:06 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43271 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0KIN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:28:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=urk2NQQnf9ERacRITx2YfgNS3PqHWBEI2AVGFgYJ3kRGUQsmrLMCbh62SrDTiHL74p
         PePsxj8B9H4wyNXzmJ0JjDz6xhWa7l5+GBiQ2PiwtC0pH12FM5pHAJGDEX6XETO1wiPn
         LikyZOUv9ow82uQu07S8Yl1K2OQWbs4Eid1oA=
From: Florian Fainelli <florian@openwrt.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Tue, 9 Nov 2010 14:27:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-server; KDE/4.5.1; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <20101107215908.GA21070@kroah.com> <AANLkTimMpGiEHgx03k22wiH-1uzAL-KJm3GADe4bBF_J@mail.gmail.com>
In-Reply-To: <AANLkTimMpGiEHgx03k22wiH-1uzAL-KJm3GADe4bBF_J@mail.gmail.com>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091427.59850.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 November 2010 00:09:33 Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Nov 7, 2010 at 4:59 PM, Greg KH <greg@kroah.com> wrote:
> > On Sun, Nov 07, 2010 at 04:44:48PM -0500, Arnaud Lacombe wrote:
> >> Hi,
> >> 
> >> On Sun, Nov 7, 2010 at 10:57 AM, Greg KH <greg@kroah.com> wrote:
> >> > [...]
> >> 
> >> Just a small comment to say that Android is not the only one (but
> >> certainly the most visible, and thus easiest to bash on) not making
> >> effort to get their stuff in mainline. OpenWRT people are also
> >> maintaining their fork of the kernel, without even using git, and not
> >> contributing much to mainline (I'm certainly mistaken on that last
> >> comment).
> > 
> > Isn't the openwrt stuff just drivers and some arch specific code?
> > Nothing that is core infrastructure, and nothing preventing them from
> > submitting the drivers and arch code if they want to, right?
> 
> From what I can see, yes.
> 
> > If so, why don't you submit it?
> 
> because I have no knowledge on the code, nor have any documentation on
> the underlying hardware. That said, it's in my TODO, but stuff keeps
> getting in before this entry.
> 
> >Why don't they?
> 
> I just checked with some dev on IRC, there might be a time issue. The
> patches have been synced with 2.6.36 recently (a month ago). So
> there're still hope :)

Of course there is, but like I told you on IRC, the best way to gather 
someone's attention is to talk to him. So far, you did not put openwrt-devel 
in copy of this thread, you should have, we are not ignoring anyone's request 
if made available.
--
Florian
