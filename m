Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2AJSJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:09:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60940 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2AJSJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <20120109172549.GA31352@phenom.dumpdata.com>
References: <20120109172549.GA31352@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 10:08:54 -0800
X-Google-Sender-Auth: iPgVXQH38HHbJM0xuM1TjlM8bGg
Message-ID: <CA+55aFxbnPstMx9Bajcq8cen7vpY_yOoGE86GG_Fu_ZUpL2zXg@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.3 patches for 3.3-rc0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, ian.campbell@citrix.com, JBeulich@suse.com,
        annie.li@oracle.com, waldi@debian.org, dgdegra@tycho.nsa.gov,
        david.vrabel@citrix.com, julia@diku.dk, tony.luck@intel.com,
        maxim.uvarov@oracle.com, anil@recoil.org, dkiper@net-space.pl,
        rdunlap@xenotime.net, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 9:25 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>  46 files changed, 2499 insertions(+), 1251 deletions(-)

Please, you too also start using -M (and --summary) for the diffstat output.

It should look like this:

  44 files changed, 1513 insertions(+), 265 deletions(-)
  create mode 100644 Documentation/ABI/stable/sysfs-bus-xen-backend
  create mode 100644 Documentation/ABI/stable/sysfs-devices-system-xen_memory
  rename drivers/xen/{xenfs => }/privcmd.c (92%)
  create mode 100644 drivers/xen/privcmd.h
  create mode 100644 drivers/xen/xenbus/xenbus_dev_backend.c
  rename drivers/xen/{xenfs/xenbus.c => xenbus/xenbus_dev_frontend.c} (95%)
  create mode 100644 include/xen/xenbus_dev.h

which is a lot more true about the *real* changes.

                      Linus
