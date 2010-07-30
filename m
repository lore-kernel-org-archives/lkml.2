Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab0G3O7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:59:18 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:43247 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab0G3O7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:59:16 -0400
Subject: Re: [RFC] [PATCH procfs] Add process age
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100728065640.GD5161@cr0.nay.redhat.com>
References: <1279907271.4335.3.camel@cowboy> <20100723183549.GA10518@x200>
	 <1279910830.1851.5.camel@cowboy> <87fwz6it0e.fsf@basil.nowhere.org>
	 <1280152668.2212.1.camel@cowboy> <20100726144848.GC17756@basil.fritz.box>
	 <1280157029.2212.17.camel@cowboy>
	 <20100728065640.GD5161@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 10:58:27 -0400
Message-ID: <1280501907.1929.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 14:56 +0800, Américo Wang wrote:
> On Mon, Jul 26, 2010 at 11:10:29AM -0400, Davidlohr Bueso wrote:
> >On Mon, 2010-07-26 at 16:48 +0200, Andi Kleen wrote:
> >> > True, but there are also many other no-so-useful files under /proc that
> >> > can also be replaced by userspace apps.
> >> 
> >> Example? 
> >
> >Off the top of my head:
> >
> >/proc/cmdline
> 
> Are you kidding?
> 
> /proc/cmdlines contains lots of info, it is not only used by the kernel,
> but also used by initramfs (this depends on your distribution).
> 
Silly me, I meant /proc/#/cmdline, in the sense that you can get the
command name from the PID in userland.

Davidlohr


