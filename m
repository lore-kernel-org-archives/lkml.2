Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2ATSrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:47:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53843 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2ATSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:47:21 -0500
Date: Fri, 20 Jan 2012 18:47:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120120184716.GB23916@ZenIV.linux.org.uk>
References: <20120120140444.GC13157@x2.net.home>
 <CAK1hOcNget=-MjeejiYGo5Vkigq9ey1o7sD2peO+tDGdk3TU9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcNget=-MjeejiYGo5Vkigq9ey1o7sD2peO+tDGdk3TU9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 07:20:33PM +0100, Denys Vlasenko wrote:
> On Fri, Jan 20, 2012 at 3:04 PM, Karel Zak <kzak@redhat.com> wrote:
> > ?BTW, systemd allows to define addition mountpoints in
> > ?systemd.mount(5) unit file(s), so we already have additional place
> > ?for fstab stuff...
> 
> systemd needs a large blunt object be stuck into its eye.
> 
> systemd was supposed to be an init replacement.
> Its continuing attempts to infiltrate entire system
> are very worrying.

I'm not saying I like /etc/foo.d/* (hell, sed in post-install is not
a big deal; not for fstab, not for inetd.conf, etc.), but yes,
complaints about changes that make life somewhat more difficult for
systemd are rather hypocritical, what with the embrace-and-extend
games they are playing.
