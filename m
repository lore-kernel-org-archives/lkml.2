Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2HODX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 23:23:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45209 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2HODXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 23:23:54 -0400
Message-ID: <502B1647.3070802@gmail.com>
Date: Tue, 14 Aug 2012 23:23:51 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jan Ariyasu <jan.ariyasu@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>
Subject: Re: [PATCH 00/13] SCTP: Enable netns
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
In-Reply-To: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 05:30 PM, Jan Ariyasu wrote:
> The following set of patches enable network-namespaces for the SCTP protocol.
>
> The multitude of global parameters are stored in a net_generic
> structure, and the bulk of the patches enable the protocol to access
> the parameters on a per-namespace basis.  The first five patches
> enable netns handling of the protocol, procfs and sysfs.
>
> Signed-off-by: Jan Ariyasu <jan.ariyasu@hp.com>
> ---
>

NACK.  Sorry Jan, but Eric's patches are much cleaner and do everything 
that's needed.

-vlad
