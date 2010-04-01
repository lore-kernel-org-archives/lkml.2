Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab0DABIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:08:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:42809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169Ab0DABIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:08:48 -0400
Message-ID: <4BB3F1DC.1090206@kernel.org>
Date: Wed, 31 Mar 2010 18:07:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <4BB3DC23.50005@zytor.com> <4BB3E0CA.5060405@kernel.org> <4BB3EA55.50505@zytor.com>
In-Reply-To: <4BB3EA55.50505@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 05:35 PM, H. Peter Anvin wrote:
> On 03/31/2010 04:54 PM, Yinghai Lu wrote:
> 
> This patch looks a lot better.  The whole use of MAX_NUMNODES as a
> sentinel (which appears inherited from mm/page_alloc.c, and as such is a
> pre-existing convention which is also invoked here) really could use a
> comment, though.

sure. will have updated one with coments there

Thanks

Yinghai
