Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1FGEKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:10:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38832 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1FGEKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110607102829.01392e7e@feng-i7>
References: <20110606071829.10334.90865.stgit@ponder> <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
 <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com> <4DED0510.1030600@gmail.com>
 <20110607102829.01392e7e@feng-i7>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 22:09:52 -0600
X-Google-Sender-Auth: eoEpNMBD9uiTaGHSMfVtTg28XK0
Message-ID: <BANLkTim927Ld28JmVfALscThef02XQJDWw@mail.gmail.com>
Subject: Re: [PATCH v2] spi: reorganize drivers
To: Feng Tang <feng.tang@intel.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 8:28 PM, Feng Tang <feng.tang@intel.com> wrote:
> On Tue, 7 Jun 2011 00:49:20 +0800
> Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
>
>> On 06/06/2011 09:38 AM, Grant Likely wrote:
>> > On Mon, Jun 6, 2011 at 10:31 AM, Mike
>> > Frysinger<vapier.adi@gmail.com>  wrote:
>> >> On Mon, Jun 6, 2011 at 03:18, Grant Likely wrote:
>> >>> Sort the SPI makefile and enforce the naming convention spi_*.c
>> >>> for spi drivers.
>> >>
>> >> spi_topcliff_pch.c uses KBUILD_MODNAME with a few funcs, but
>> >> perhaps those are only for /proc/ status tracking ?  worth double
>> >> checking ...
>> >
>> > I just talked with Dirk Brandewie, who has a major rewrite to the
>> > topcliff spi driver.  I'll let him comment on whether or not
>> > changing KBUILD_MODNAME will cause any problems.
>> >
>>
>> My changes are to the designware driver :-) I will get my patches
>> re-based onto the spi-next branch and see if there any issues.
>
> If there is major rewrite to the dw_spi driver, please submit to this
> list, as it is used by many devices out there and needs a broad review

Hmmm.  Dirk, that could change things a bit.  From our conversation
today my understanding was that there weren't few if any users outside
of your circle.  If that isn't the case, then I'm going to be more
cautious about merging the rewrite.  Who are the people I should make
sure there is feedback from when the patch gets posted?

g.
