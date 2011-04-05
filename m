Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1DEM6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:58:53 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:62158 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1DEM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eBYM6vh+edCmfypnGlQVV9/EtX6EtjNNjfyYehxyx/HAgRjsgVhLZzn68bp6UmqKT0
         cdlAlzuMXfpdI1YojlH+bGZUc94sIzhY4A1Jn7EsKb+MECdYAmuosICSpZqcdpc9qRax
         G/2hy3xc2Cii28OnLRx5C4Gme4LkeK8iSYW18=
Message-ID: <4D9B120A.2060305@gmail.com>
Date: Tue, 05 Apr 2011 06:58:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Native KVM: can't boot existing Fedora 14 image
References: <4D9A7DF6.1040101@gmail.com> <1301991791.1923.12.camel@t41.thuisdomein>
In-Reply-To: <1301991791.1923.12.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/05/11 02:23, Paul Bolle wrote:
> On Mon, 2011-04-04 at 20:27 -0600, David Ahern wrote:
>> At that point it loops over a few iterations of the last few lines and I
>> kill it. Any ideas why?
> 
> What happens if you remove the (hardcoded) "root=vda" kernel parameter
> from the commandline (in tools/kvm/main.c)?

It boots. :-)

Thanks,

David

> 
> 
> PUal Bolle
> 
