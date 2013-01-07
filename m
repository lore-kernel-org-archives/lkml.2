Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3AGJzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:55:40 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:35715 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab3AGJzj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:55:39 -0500
Subject: Re: Fix test relying in wrong behavior of is_printable
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <E1TryU3-0001K5-Iy@jdl.com>
Date: Mon, 7 Jan 2013 11:55:32 +0200
Cc: David Gibson <david@gibson.dropbear.id.au>, Matt Porter <mporter@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6BBCA320-AB8C-4DE3-BF98-3A77B1E94982@antoniou-consulting.com>
References: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com> <20130106035809.GG4674@truffula.fritz.box> <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com> <E1TryU3-0001K5-Iy@jdl.com>
To: Jon Loeliger <jdl@jdl.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Err,

I can rework and resubmit to remove the comment, but the test doesn't fail:

> $ make check | grep 'MyBoardName.*-t s.*compatible' 
> fdtget-runtest.sh MyBoardName MyBoardFamilyName -t s label01.dts.fdtget.test.dtb / compatible:	PASS
> 

As of today's pull.

Regards

-- Pantelis

On Jan 7, 2013, at 12:14 AM, Jon Loeliger wrote:

>> Hi David
>> 
>> =CE=91=CF=80=CF=8C =CF=84=CE=BF iPhone =CE=BC=CE=BF=CF=85
>> 
>> 6 =CE=99=CE=B1=CE=BD 2013, 5:58, =CE=BF/=CE=B7 David Gibson <david@gibson.dr=
>> opbear.id.au> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
>> 
>>> On Fri, Jan 04, 2013 at 09:16:08PM +0200, Pantelis Antoniou wrote:
>>>> After fixing the is_printable bug the test suite fails.
>>>> Fix it with this patch
>>>> =20
>>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>> =20
>>> Rather than just removing the test, it would be better to still run it
>>> using an explicit -t bi to force the byte output.
>> 
>> Perhaps it wasn't exactly clear in the patch. The old test case output is co=
>> mmented out but there is test case output for the new patch.=20
>> 
>> So the test is not removed.=20
> 
> Uh, yeah, something needs to be done here still.
> (There is a failing test still.)
> 
> Could we get a resubmission of the fix, please?
> 
> Thanks,
> jdl

