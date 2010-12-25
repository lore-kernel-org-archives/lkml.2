Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab0LYLXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 06:23:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39665 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0LYLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 06:23:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xW8KLFFU0S9A3HAIf4tJWJw9jPJ8ruTodD/wlpY+G2u0B3CnVWKGDSrBJ1yTnfk1Vu
         AaAf7NRJdaTsPmPvZRmOtKrOpLc3Gat9I/AFUyt6hzwEzaG0HshKvQAk5Mjod7hS024Z
         aZJbqWKTxCATtPKpvrq/mp1TCE1KmYxMO3dZU=
Message-ID: <4D15D347.6050500@gmail.com>
Date: Sat, 25 Dec 2010 12:19:35 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <David.Woodhouse@intel.com>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, Bugfix] RAMOOPS: Don't overflow over non-allocated regions
References: <20101225095709.GA1345@laptop>
In-Reply-To: <20101225095709.GA1345@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/12/2010 10:57, Ahmed S. Darwish ha scritto:
> Hi,
> 
> Current code mis-calculates the ramoops header size, leading to an
> overflow over the next record at best, or over a non-allocated region
> at worst. Fix that calculation.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> --

Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
