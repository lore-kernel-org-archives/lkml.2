Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0LOMgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:36:45 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:41587 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0LOMgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:36:44 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Dec 2010 07:36:43 EST
MIME-Version: 1.0
In-Reply-To: <20101214235746.GB21913@flint.arm.linux.org.uk>
References: <20101215105435.3ce83f21.sfr@canb.auug.org.au>
	<20101214235746.GB21913@flint.arm.linux.org.uk>
Date: Wed, 15 Dec 2010 12:28:39 +0000
Message-ID: <AANLkTimdZ3FRs82RzSZR19gDJbkNe2UfEY-kLQOwvd_Q@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current tree
From: Dave Martin <dave.martin@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 14, 2010 at 11:57 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Wed, Dec 15, 2010 at 10:54:35AM +1100, Stephen Rothwell wrote:
>> Hi Russell,
>>
>> Today's linux-next merge of the arm tree got a conflict in
>> arch/arm/Kconfig between commit 6e6fc998b8c127fe06b9350a1f16e41bfe4f109d
>> ("ARM: 6533/1: Thumb-2: Make CONFIG_THUMB2_KERNEL depend on !CPU_V6")
>> from the arm-current tree and commit
>> 4a50bfe365a977f634311504484342fbfffe855c ("ARM: Ensure experimental
>> options are so marked") from the arm tree.
>>
>> Just context changes.  I fixed it up (see below) and can carry the fix as
>> necessary.
>
> Yea, rather unfortunate.  I'll fix it up locally once arm-current is
> merged into mainline.

Looks like this was a case of two simple changes on neighbouring lines
-- I'll try to avoid such conflicts for the future.

Cheers
---Dave
