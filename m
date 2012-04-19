Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2DSP3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:29:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49188 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2DSP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:28:58 -0400
Date: Thu, 19 Apr 2012 08:28:51 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mark Gross <mark.gross@intel.com>, Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] edac: change the mem allocation scheme to make
 Documentation/kobject.txt happy
Message-ID: <20120419152851.GD31543@kroah.com>
References: <1334697467.3920.5.camel@joe2Laptop>
 <1334841690-305-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334841690-305-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:21:30AM -0300, Mauro Carvalho Chehab wrote:
> Kernel kobjects have rigid rules: each container object should be
> dynamically allocated, and can't be allocated into a single kmalloc.
> 
> EDAC never obeyed this rule: it has a single malloc function that
> allocates all needed data into a single kzalloc.
> 
> As this is not accepted anymore, change the allocation schema of the
> EDAC *_info structs to enforce this Kernel standard.

Very nice work, thanks for doing this:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

