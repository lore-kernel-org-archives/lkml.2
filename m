Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2K1Vzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:55:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40604 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab2K1Vzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:55:35 -0500
Message-ID: <50B6881F.7090101@zytor.com>
Date: Wed, 28 Nov 2012 13:54:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/46] x86, mm: map ram from top-down with BRK and
 memblock.
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 01:47 PM, Yinghai Lu wrote:
> rebase patchset on top of linus v3.7-rc4. this one replace patches in tip/x86/mm2

What are the changes?  Given how close we are to the merge window, if we
replace the entire patchset we are *definitely* slipping this to 3.9.
Depending on what the changes are we might not have to do so, but we
need them detailed.

	-hpa


