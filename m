Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab0KQGAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:00:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56600 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0KQGAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:00:17 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimTks01SnjWJZFycSCQC+ZBEonPLLUwMRQkxLz2@mail.gmail.com>
References: <20101116204917.12146.39851.stgit@riker> <20101116204951.12146.21084.stgit@riker>
 <AANLkTimTks01SnjWJZFycSCQC+ZBEonPLLUwMRQkxLz2@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Nov 2010 22:59:55 -0700
X-Google-Sender-Auth: Vn-rUZPw44is6UL6Asdt1rF1r6I
Message-ID: <AANLkTinZ0yi-ZdwjG-KNcjXBuBzNMxrsFRJq4NZOiwk=@mail.gmail.com>
Subject: Re: [PATCH 1/5] scripts: dtc: Merge in changes from the dtc repository
To: Kyle Moffett <kyle@moffetthome.net>
Cc: John Bonesio <bones@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, jdl@jdl.com,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:56 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
> On Tue, Nov 16, 2010 at 15:49, John Bonesio <bones@secretlab.ca> wrote:
>> Pull in recent changes from the main dtc repository. These changes primarily
>> allow multiple device trees to be declared which are merged by dtc. This
>> feature allows us to include a basic dts file and then provide more information
>> for the specific system through the merging functionality.
>
> Hmm, is there some documentation for how to use this feature?
> Specifically I have a custom board with multiple discrete computers on
> it which are only very slightly physically different from each other
> and I'd like to be able to avoid maintaining 2 nearly-exact copies of
> the same DTS file.

Not yet, but there will be.

g.
