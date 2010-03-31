Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0CaITX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:19:23 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:37271 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab0CaITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i24VahmQmrlDnaoJblLSTHQWZiIHH3UconIDv4A8EMoIq1Juhm356GBvqsfvldBS4E
         IM0al+OLfymgpaE0qpKSN5VoBfjH2r0LFtneXbHDYh4XIRyg+87TAhxmwWcCrSSCjE0i
         fEIZZAoY1+yt69gi9EnEOl1Wmf6LgQEMy58aY=
Message-ID: <4BB30644.9090809@gmail.com>
Date: Wed, 31 Mar 2010 17:22:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       netdev@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 3/6] sysfs: Implement sysfs tagged directory support.
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>	<1269973889-25260-3-git-send-email-ebiederm@xmission.com>	<4BB2F083.1050803@kernel.org> <m11vf12ayb.fsf@fess.ebiederm.org> <4BB30520.2030100@kernel.org>
In-Reply-To: <4BB30520.2030100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanna add a bit more.

On 03/31/2010 05:17 PM, Tejun Heo wrote:
> If you think all those callbacks are absolute necessities, can you
> please at least add boatload of comments around them explaning what
> they're meant to do and how they're gonna be used?  It's probably
> because I don't have any experience with namespaces but I really can't
> wrap my head around it as it currently stands.

The reason why I talked about proper layering is the same reason.
It's very difficult to review your code because I have no idea how
those callbacks are meant to be used and gonna behave and that lowers
maintainability significantly in the long run.  If at all possible,
please make it implement a discrete function which is used to
implement something higher up.  If it's already done like that and I'm
just being stupid, please feel free to enlighten me.

Thanks.

-- 
tejun
