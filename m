Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2GEOUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:20:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48673 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2GEOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:20:43 -0400
Message-ID: <4FF5A2B7.4010401@gmail.com>
Date: Thu, 05 Jul 2012 09:20:39 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] of: return -ENOENT when no property
References: <1340945879-11712-1-git-send-email-acourbot@nvidia.com> <1340945879-11712-2-git-send-email-acourbot@nvidia.com> <CACRpkdbjHCc0pud8hnjJi1AMM5XQUmS=duhSnzXO+QO29YLk0A@mail.gmail.com>
In-Reply-To: <CACRpkdbjHCc0pud8hnjJi1AMM5XQUmS=duhSnzXO+QO29YLk0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 08:26 AM, Linus Walleij wrote:
> On Fri, Jun 29, 2012 at 6:57 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
>> Make of_parse_phandle_with_args return -ENOENT instead of -EINVAL when
>> no matching property is found, which allows to discriminate between
>> absence of property and parsing error.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Rob can you take this into the DT git?

Yes.

Rob

