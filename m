Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab1ERTXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:23:20 -0400
Received: from mx1.unsolicited.net ([173.255.193.191]:40468 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681Ab1ERTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:23:19 -0400
Message-ID: <4DD41CA6.8060808@unsolicited.net>
Date: Wed, 18 May 2011 20:23:18 +0100
From: David <david@unsolicited.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel fails to build multi-threaded on ecryptfs home
References: <4DD41613.4040102@unsolicited.net>
In-Reply-To: <4DD41613.4040102@unsolicited.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/11 19:55, David wrote:
> I'm seeing some unpleasant things when building multithreaded when running the latest kernels. The compiler complains of truncated files and implausible characters. Single threaded builds seem fine.

My impromptu bisection currently shows

    2.6.38 OK
    2.6.39rc2 Affected

so it looks like this problem first appears early in the .39 series.

Cheers
David
