Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2EBI67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:58:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64257 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab2EBI65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:58:57 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120502023836.GW3157@wantstofly.org>
References: <CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com>
	<20120427101732.GX3157@wantstofly.org>
	<CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com>
	<CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com>
	<20120427185809.GZ3157@wantstofly.org>
	<CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com>
	<CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com>
	<20120501125102.GN3157@wantstofly.org>
	<CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
	<4FA089F9.1020602@erley.org>
	<20120502023836.GW3157@wantstofly.org>
Date: Wed, 2 May 2012 10:58:56 +0200
Message-ID: <CA+icZUVLKEs4YAiByqeUpD6cRUyF+bvb2SY=PYebDKU8b+653A@mail.gmail.com>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Pat Erley <pat-lkml@erley.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lautriv <admin@coldplug.net>,
        Jim Cromie <jim.cromie@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 4:38 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Tue, May 01, 2012 at 09:12:25PM -0400, Pat Erley wrote:
>
>> >--- a/drivers/net/wireless/mwl8k.c
>> >+++ b/drivers/net/wireless/mwl8k.c
>> >@@ -5225,6 +5225,7 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
>> >  }
>> >
>> >  enum {
>> >+    MWL8361P = 0,
>> >     MWL8363 = 0,
>> >     MWL8687,
>> >     MWL8366,
>>
>> I'm not an expert, but isn't this giving both 8361P and 8363 the
>> same values in the enum?
>
> Yeah, this is broken.

Before this email, Helmut pointed me to the enum thingie in a private query.
As I was busy with OverlayFS the last days, I couldn't give that
information back.

So, this should be:
...
  enum {
     MWL8361P = 0,
     MWL8363,
     MWL8687,
     MWL8366,
...

Shall I cook up a new patch with a proper history and documented
origin (original patch is from OpenWrt, I refreshed it against
upstream)?
...add some Tested-by (Helmut, Jim)...
...send that to linux-wireless ML for a review?

- Sedat -
