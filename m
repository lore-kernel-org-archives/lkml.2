Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab1BQVVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:21:08 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:56909 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab1BQVVH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:21:07 -0500
MIME-Version: 1.0
In-Reply-To: <20110211080138.GG4384@bicker>
References: <1297382566-18748-1-git-send-email-klaas.neirinck@gmail.com>
	<20110211080138.GG4384@bicker>
Date: Thu, 17 Feb 2011 15:21:05 -0600
Message-ID: <AANLkTi=a+nkQ16ngpkztKdGwriGdMFA=jFVQGQH0Niok@mail.gmail.com>
Subject: Re: [PATCH] Staging: tidspbridge: fixed several coding style issues
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Dan Carpenter <error27@gmail.com>,
        Klaas Neirinck <klaas.neirinck@gmail.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 11, 2011 at 2:01 AM, Dan Carpenter <error27@gmail.com> wrote:
> On Fri, Feb 11, 2011 at 01:02:46AM +0100, Klaas Neirinck wrote:
>> Fixed several coding style issues.
>>
>> Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>
> ---                             dest = ibuf.bufr;
>>  #ifdef OPT_ZERO_COPY_LOADER
>>                               zero_copy = false;
>> -                             if (!dload_check_type(sptr, DLOAD_CINIT) {
>> +                             if (!dload_check_type(sptr, DLOAD_CINIT)) {
>>                                       dlthis->myio->writemem(dlthis->myio,
>>                                                              &dest,
>
> Also it apparently fixes a compile problem?  Why not say that in the
> change log...  :/

I don't think this is present in staging-next anymore.

OPT_ZERO_COPY_LOADER was removed as it was dead code.

Regards,

Omar
