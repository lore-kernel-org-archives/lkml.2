Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0JLHHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:07:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44242 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0JLHG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:06:58 -0400
Subject: Re: [PATCHv3 0/5] [PATCHv3 0/6] BH1770GLC, SFH7770 and APDS990x
 als / proximity sensor drivers
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1286795209-12487-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286795209-12487-1-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Tue, 12 Oct 2010 10:05:31 +0300
Message-Id: <1286867131.24536.13.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Oct 2010 07:05:36.0746 (UTC) FILETIME=[DED534A0:01CB69DB]
X-Nokia-AV: Unscannable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 13:06 +0200, ext Samu Onkalo wrote:
> Patch set contains two drivers. One for BH1770GLC / SFH7770 chips and
> one for APDS990X chip.
> 

Hi

First of all, thanks for reviewing my patches.

patchesV3 1, 3 and 5 are Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Changes requested to the patches 2 an 4 (Makefile and Kconfig changes)
are also done in version 3 patch set. I quess that they can also be
acked.

Who will take care of the patches now - Andrew or Jean?

-Samu


