Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1KDEUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 00:20:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53135 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1KDEUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 00:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6uAKBrkxQ2puiO+hhcymXTjev3LG=0kzaSeGnsEHdeX6A@mail.gmail.com>
References: <CACxGe6t-xaH4U9F7uGOabYD-KKSHZNyQ3Ds036FhubScqR=vGQ@mail.gmail.com>
 <CACxGe6uAKBrkxQ2puiO+hhcymXTjev3LG=0kzaSeGnsEHdeX6A@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 4 Nov 2011 00:19:43 -0400
X-Google-Sender-Auth: 1w50DrLaq44PgQyfCxFvF37bVz0
Message-ID: <CACxGe6vOqjmmoV+6pT+HM6f8hK+9UVvF10SijGSS2DKiGSwSAg@mail.gmail.com>
Subject: Re: [GIT PULL] A few more device tree changes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <SWarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Updated pull req, this time with feeling (and the branch actually pushed out)

g.

The following changes since commit d6748066ad0e8b2514545998f8367ebb3906f299:

  Merge branch 'upstream' of
git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2011-11-03
13:28:14 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Grant Likely (1):
      Merge branch 'for-grant' of
git://sources.calxeda.com/kernel/linux into devicetree/merge

Nicolas Ferre (1):
      dt: add empty of_alias_get_id() for non-dt builds

Olof Johansson (1):
      dt/platform: minor cleanup

Rob Herring (1):
      ahci: add DT binding for Calxeda AHCI controller

Stephen Warren (1):
      dt: add empty of_machine_is_compatible

 .../devicetree/bindings/ata/calxeda-sata.txt       |   17 ++++++++++++
 drivers/ata/ahci_platform.c                        |    7 +++++
 drivers/of/platform.c                              |   28 +++++++++++--------
 include/linux/of.h                                 |   10 +++++++
 4 files changed, 50 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/calxeda-sata.txt


On Fri, Nov 4, 2011 at 12:01 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Nov 3, 2011 at 11:56 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Hi Linus,
>>
>> A few more for 3.2.  Nothing exciting here.
>>
>> g.
>>
>> The following changes since commit d6748066ad0e8b2514545998f8367ebb3906f299:
>>
>>  Merge branch 'upstream' of
>> git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2011-11-03
>> 13:28:14 -0700)
>>
>> are available in the git repository at:
>>
>>  git://git.secretlab.ca/git/linux-2.6 ..BRANCH.NOT.VERIFIED..
>
> Okay, well that was stupid.  I'll push out the branch and send out a
> new pull req.
>
> g.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
