Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1BXPFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:05:04 -0500
Received: from mail.in-telegence.net ([83.125.45.125]:47808 "EHLO
	amg.in-telegence.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752809Ab1BXPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:05:00 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Feb 2011 10:05:00 EST
X-CTCH-RefID: str=0001.0A0B0204.4D66720E.029A,ss=1,fgs=0
Message-ID: <4D66720E.70102@in-telegence.net>
Date: Thu, 24 Feb 2011 15:58:22 +0100
From: Dominik Klein <dk@in-telegence.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
References: <4D621B9B.3070205@in-telegence.net> <4D622002.2040604@in-telegence.net> <4D6222A8.6090303@in-telegence.net> <20110221184442.GM6428@redhat.com> <4D63BA3B.7070809@in-telegence.net> <20110222152426.GD28269@redhat.com> <20110222190953.GF28269@redhat.com> <4D650D7E.4050908@in-telegence.net> <4D662248.6040405@in-telegence.net> <20110224142303.GA18494@redhat.com> <20110224143105.GL7840@htj.dyndns.org>
In-Reply-To: <20110224143105.GL7840@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hmmm...  Maybe the following commit?
> 
> commit 7576958a9d5a4a677ad7dd40901cdbb6c1110c98

Unfortunately not. This does not fix it for me.

Vivek introduced me to git bisect and I will try to do that tomorrow to
find the changeset.

Will report back.

Thanks
Dominik
