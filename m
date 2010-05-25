Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0EYFjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:39:32 -0400
Received: from mail.comedia.it ([77.93.254.181]:44981 "EHLO maude.comedia.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab0EYFja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:39:30 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 01:39:29 EDT
Date: Tue, 25 May 2010 07:33:41 +0200
From: Luca Berra <bluca@comedia.it>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>, dm-devel@redhat.com
Subject: Re: [dm-devel] add devname module aliases to allow module
	on-demand auto-loading
Message-ID: <20100525053341.GB31345@maude.comedia.it>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <chris.mason@oracle.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Ian Kent <raven@themaw.net>, dm-devel@redhat.com
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> <201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> <20100521182325.GO3991@agk-dp.fab.redhat.com> <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 08:51:49PM +0200, Kay Sievers wrote:
>On Fri, May 21, 2010 at 20:23, Alasdair G Kergon <agk@redhat.com> wrote:
>> On Fri, May 21, 2010 at 03:55:21PM +0200, Kay Sievers wrote:
>>> >> On my box without this patch:
>>> >>   dmsetup version
>>> >>   Library version:   1.02.42 (2010-01-14)
>>> >>   /proc/misc: No entry for device-mapper found
>>> >>   Is device-mapper driver missing from kernel?
>>> >>   Failure to communicate with kernel device-mapper driver.
>>
>> (Curiously this is not an issue I remember anyone raising with me as a problem
>> before.)
I am fairly sure i did report that, i even tried moving the module
loading framework from lvm2 to device mapper, but the resulting code
sucked too much to submit, the idea was to load device-mapper module,
and all target modules on first use.

>Because distros go the easy and stupid way and just load everything
>they configured as a module. :) That is something to solve, or at
>least avoid and hide a bit.
In this case we were forced to preload dm-mod to work around the issue
;)

>
>I think its all covered with this patch. :) But if yo have any better
>idea, let us know.

what patch?

L.
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
