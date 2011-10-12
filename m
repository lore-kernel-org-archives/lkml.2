Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1JLEY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:24:26 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:33127 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1JLEYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:24:25 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 00:24:25 EDT
Message-ID: <4E9513EA.2070709@hardwarefreak.com>
Date: Tue, 11 Oct 2011 23:13:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        aradford@gmail.com, xfs@oss.sgi.com
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O
 load
References: <20111011091757.GA32589@otto.nzcorp.net> <20111011133448.GA10692@infradead.org> <20111011141338.GA11808@otto.nzcorp.net> <20111012003526.GI3159@dastard>
In-Reply-To: <20111012003526.GI3159@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 7:35 PM, Dave Chinner wrote:

> FWIW, if it's a repeatable problem, you might want to update the
> driver and controller firmware to something more recent and see if
> that solves the problem....

New firmware was released on 08/11/2011 for the SAS2208 dual core ASIC
based cards, the 9265-8i and 9285-8i.  I'd say the odds are good that
the OP's card(s) shipped with the original firmware, given this one was
released exactly two months ago today.

Complete list of bug fixes and enhancements in this firmware:
http://kb.lsi.com/KnowledgebaseArticle16557.aspx

I didn't count them but it looks like a few hundred, which makes this a
major product refresh, and seems to indicate the original firmware for
these two cards was a bit buggy.  This is the 2nd firmware release.

Firmware file:
http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/23.1.1-0004_SAS_FW_Image_3.140.15-1320.zip

-- 
Stan
