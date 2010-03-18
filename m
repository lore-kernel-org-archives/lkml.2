Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0CRRPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:15:54 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:56068 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0CRRPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100318125939.2b39d7f2@lappy.seanm.ca>
References: <20100318144836.21082.93040.stgit@angua> <20100318152238.21082.10985.stgit@angua> 
	<20100318125939.2b39d7f2@lappy.seanm.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Mar 2010 11:07:35 -0600
X-Google-Sender-Auth: 3142ffdffff6694f
Message-ID: <fa686aa41003181007k9202cd6n44d2d3997ef626a1@mail.gmail.com>
Subject: Re: [V2 PATCH 06/10] of/drivers: Always use struct device.of_node to 
	get node pointer
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 10:59 AM, Sean MacLennan
<smaclennan@pikatech.com> wrote:
> On Thu, 18 Mar 2010 09:22:39 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> The following structure elements duplicate the information in
>> 'struct device.of_node' and so are being eliminated.  This patches
>> makes all readers of the following elements use device.of_node
>> instead.
>
> The NDFC driver also needs a patch... or at least the version from your
> last of_patch set does. I am included the patch I needed to get it to
> compile.

Thanks Sean, I've added this patch to my series.  s-o-b line please?

g.
