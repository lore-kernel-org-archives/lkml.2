Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2AaUWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:22:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44052 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2AaUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:22:15 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.140.105]
In-Reply-To: <20120131200852.GC22611@ponder.secretlab.ca>
References: <1328028762-28352-1-git-send-email-ohad@wizery.com>
 <1328028762-28352-2-git-send-email-ohad@wizery.com> <4F282BB2.6080604@fastmail.fm>
 <20120131200852.GC22611@ponder.secretlab.ca>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 31 Jan 2012 22:21:54 +0200
Message-ID: <CAK=WgbZuR1=0+Zd+jNpFtugy_SSp0Z3c0jTkUZgG5mF21EicUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: s/big switch/lookup table/
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jack Stone <jwjstone@fastmail.fm>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Grosen <mgrosen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:08 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Tue, Jan 31, 2012 at 05:58:10PM +0000, Jack Stone wrote:
>> On 31/01/12 16:52, Ohad Ben-Cohen wrote:
>> [RSC_CARVEOUT] = rproc_handle_carveout,

That looks great.

Thanks!
