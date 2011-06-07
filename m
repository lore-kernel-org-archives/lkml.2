Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1FGEtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:49:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56090 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1FGEtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jhxSWMVAMRJ4N4x9pFDY2tMAp5HQEcQeW0mmSBWFlbWB6lE/u1CeZRU4JkL1TI3Gqp
         SweKI/mhCsR10BSFfhW2SgNkZt2wGRJG3Id5xQFoUlHDj+uh8mJiaQRid6pjO84yGDwg
         gu/cQQoo95x0HR++Gxnd6beMc4BfSoNjehqQg=
MIME-Version: 1.0
In-Reply-To: <20110607124854.0e96813c@feng-i7>
References: <20110606071829.10334.90865.stgit@ponder> <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
 <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com> <4DED0510.1030600@gmail.com>
 <20110607102829.01392e7e@feng-i7> <BANLkTim927Ld28JmVfALscThef02XQJDWw@mail.gmail.com>
 <20110607124854.0e96813c@feng-i7>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 7 Jun 2011 00:48:49 -0400
Message-ID: <BANLkTimOnT-McWYp9ym6nZSPsDWQVKCUBQ@mail.gmail.com>
Subject: Re: [PATCH v2] spi: reorganize drivers
To: Feng Tang <feng.tang@intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alek.du@intel.com, alan@linux.intel.com,
        jean-hugues.deschenes@octasic.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 00:48, Feng Tang wrote:
> On Tue, 7 Jun 2011 12:09:52 +0800 Grant Likely wrote:
>> On Mon, Jun 6, 2011 at 8:28 PM, Feng Tang wrote:
>> > On Tue, 7 Jun 2011 00:49:20 +0800 Dirk Brandewie wrote:
>> >> My changes are to the designware driver :-) I will get my patches
>> >> re-based onto the spi-next branch and see if there any issues.
>> >
>> > If there is major rewrite to the dw_spi driver, please submit to
>> > this list, as it is used by many devices out there and needs a
>> > broad review
>>
>> Hmmm.  Dirk, that could change things a bit.  From our conversation
>> today my understanding was that there weren't few if any users outside
>> of your circle.  If that isn't the case, then I'm going to be more
>> cautious about merging the rewrite.  Who are the people I should make
>> sure there is feedback from when the patch gets posted?
>
> I don't know all the devices and users, but here is what I know: I've tested
> Max3110 spi-uart (in-tree), Option GTM501L high-speed 3G modem (out of tree),
> ektf1236 spi touch screen (out of tree). Alek Du (Cced) should have tested
> current dw_spi driver with some spi bluetooth device and modem device. Also
> the original author fordw_spi_mmio.c Jean-Hugues Deschense should have some
> experience too.

sounds like if there are multiple CPUs with this IP being added to
them, then perhaps a top level MAINTAINERS entry should be added so
interested parties can easily be located ... or listing in the
drivers/spi/Kconfig under the designware entry ... or a listing in the
designware spi driver itself ...
-mike
