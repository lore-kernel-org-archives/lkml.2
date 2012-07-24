Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2GXKRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:17:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2GXKRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:17:03 -0400
Message-ID: <500E761B.4040705@nod.at>
Date: Tue, 24 Jul 2012 12:16:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Guillem Jover <guillem@hadrons.org>
CC: Jesper Juhl <jj@chaosbits.net>, Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: st_size of a symlink
References: <500D73FF.1070504@nod.at> <alpine.LNX.2.00.1207231959410.1922@swampdragon.chaosbits.net> <20120723202224.GH31729@ZenIV.linux.org.uk> <alpine.LNX.2.00.1207232243110.1922@swampdragon.chaosbits.net> <500DCB34.6050209@nod.at> <20120723231333.GA1299@gaara.hadrons.org>
In-Reply-To: <20120723231333.GA1299@gaara.hadrons.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.07.2012 01:13, Guillem Jover wrote:
> Well, can't the link be accessed when getting the stat information
> then?

Sure, but it's not trivial.

>> IMHO the lstat() and readlink() manpages have to be more precise
>> about st_size.
>
> They document what POSIX says:

This does not make it any better...

Thanks,
//richard
