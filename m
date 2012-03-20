Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059Ab2CTIj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:39:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab2CTIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:39:04 -0400
Message-ID: <4F684221.6080608@canonical.com>
Date: Tue, 20 Mar 2012 16:38:57 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: kernel-team@lists.ubuntu.com, 959959@bugs.launchpad.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH precise] powerpc/pmac: Fix SMP kernels on pre-core99 UP
 machines
References: <1332228453.147584.181533989908.1.gpush@pecola> <CAJL_dMsTD6P_Ff_4u9mWGJhRvVQr2Ph2zAp3Lwfmz6Z8kgptnQ@mail.gmail.com>
In-Reply-To: <CAJL_dMsTD6P_Ff_4u9mWGJhRvVQr2Ph2zAp3Lwfmz6Z8kgptnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anca,

> Why not CC: lkml ?


Because it's already in mainline. Refer:

 > Cherry-picked from upstream commit
 > 78c5c68a4cf4329d17abfa469345ddf323d4fd62

  

Cheers,


Jeremy
