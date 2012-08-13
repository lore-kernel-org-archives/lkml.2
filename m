Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2HMUnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:43:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59516 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2HMUnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:43:14 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 13 Aug 2012 13:42:53 -0700
X-Google-Sender-Auth: Jo4998UxLDjYgdaJGzPqSz_CYZk
Message-ID: <CAB=NE6W_SQUJmAXaLesyRShtQ=Urz=w5Ks5jEXq_50bRge+PWQ@mail.gmail.com>
Subject: Backports mailing list
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        lf_driver_backport@lists.linux-foundation.org,
        Julia Lawall <julia.lawall@lip6.fr>, Jesper Andersen <jespera@diku.dk>,
        =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

The compat [0] / compat-wireless [1] [2] projects have received quite
a bit of love of the years to the point we now have 3 subsystems
backported: Ethernet, Bluetooth and 802.11. Ozan Çağlayan, a Linux
Foundation Google Summer of Code student is folding in right now drm
driver support. At the request of the community, specifically those
part of the Linux Foundation driver working group [3], we are going to
be renaming the project to compat-drivers soon after drm is integrated
and will be housing documentation under the kernel.org infrastructure
[4] under this new name. It'll take some time for us to migrate the
documentation / releases but do not see major issues with that, it
will just take a bit of time but hope to have it done for the next
stable release based on the next kernel stable release. At this time
for patches we do have a Linux Foundation mailing list but have had
issues with it for a while now so we keep using linux-wireless for
patches. Given that our focus is to always prioritize upstream and
always try to work with solutions that ensure vendors are focusing on
upstream solutions and prioritizing upstream [5] I was hoping we can
get a mailing list set up on vger for the project, perhaps
backports@vger.kernel.org, so we don't flood the other mailing lists
with random kernel backport junk. Please let me know if this is
reasonable.

[0] https://github.com/mcgrof/compat
[1] http://wireless.kernel.org/en/users/Download/
[2] http://wireless.kernel.org/en/users/Download/stable/
[3] http://www.linuxfoundation.org/collaborate/workgroups/driver-backport/group
[4] https://backports.wiki.kernel.org
[5] http://wireless.kernel.org/en/users/Download/stable/#Additional_patches_to_stable_releases

  Luis
