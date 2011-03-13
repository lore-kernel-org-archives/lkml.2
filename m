Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1CMMxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 08:53:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54654 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab1CMMxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 08:53:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andy.green@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach api
Date: Sun, 13 Mar 2011 13:53:54 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131141.07380.rjw@sisk.pl> <4D7CB15A.6030203@linaro.org>
In-Reply-To: <4D7CB15A.6030203@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131353.54612.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Andy Green wrote:
> On 03/13/2011 10:41 AM, Somebody in the thread at some point said:
> > On Sunday, March 13, 2011, Greg KH wrote:
> >> On Sat, Mar 12, 2011 at 10:32:27PM +0000, Andy Green wrote:
> >>> This introduces a platform API so busses can allow platform_data to
> >>> be attached to any struct device they create from probing in one step.
> >>>
> >>> The function checks through the async platform_data map if one was
> >>> previously registered, and checks the device's device path for itself
> >>> and its parents against the mapped device path names.
> >>>
> >>> If it sees a match, it attaches the associated platform_data and sets
> >>> that map entry's device_path to NULL so no further time is spent trying
> >>> to match it.
> >>
> >> This _really_ should just use the device tree stuff, that is what it is
> >> for, please don't duplicate it here in a not-as-flexible way.
> >
> > I agree.
> >
> > @Andy: If it doesn't work for you for some reason, please let us know the
> > usage case that is not covered (in detail).
> 
> The device tree stuff does not yet exist in a workable way, 
> platform_data is established everywhere except USB bus.  Device tree 
> brings in bootloader version as a dependency: this method doesn't.

It is not the same device tree we are talking about. :-)

I mean device hierarchy (and I guess Greg meant the same).

Thanks,
Rafael
