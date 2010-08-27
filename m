Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0H0Ssz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:48:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54679 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab0H0Ssx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:48:53 -0400
Message-ID: <4C780888.9000301@zytor.com>
Date: Fri, 27 Aug 2010 11:48:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com>
In-Reply-To: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're doing user-space references without get_user().

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

