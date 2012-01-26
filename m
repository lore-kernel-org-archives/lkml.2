Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2AZNiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:38:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33972 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2AZNix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:38:53 -0500
MIME-Version: 1.0
In-Reply-To: <1327532011.24169.6.camel@deneb.redhat.com>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca> <1327532011.24169.6.camel@deneb.redhat.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 Jan 2012 06:38:33 -0700
X-Google-Sender-Auth: DGPvKHuxy5a8rwH-9eKZUow9Vfc
Message-ID: <CACxGe6t9VO14uY4amSd=s=htQpRn7H40rmB3k6jnmptW9ffxtQ@mail.gmail.com>
Subject: Re: [RFCv2 00/14]
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 3:53 PM, Mark Salter <msalter@redhat.com> wrote:
> On Mon, 2012-01-23 at 14:07 -0700, Grant Likely wrote:
>> Hey everyone,
>>
>> Here's the second RFC for the irq_domain patches.  I could use some
>> help testing now.  I still expect there will be a few bugs.  The
>> series is based on v3.3-rc1, and I've pushed it out to my git server:
>
> Hi Grant,
>
> I converted arch/c6x over to the generic irq_domain support and have not
> had any problems in testing. The c6x virtual irq support was a nearly
> identical copy of the powerpc code, so the patch I ended up with mostly
> copied what you did in arch/powerpc. The c6x patch is on the tip of:
>
>  git@linux-c6x.org:/git/projects/linux-c6x-upstreaming irq-testing
>
> I think this probably belongs in your series, but I can push it
> separately if not.

Yes, it should be in my series.  Please post the patches and cc me so
there is record of them in the mailing list archives and I'll pick
them up.

g.
