Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1BYQ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:56:23 -0500
Received: from mail.in-telegence.net ([83.125.45.125]:41796 "EHLO
	amg.in-telegence.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932468Ab1BYQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:56:22 -0500
X-CTCH-RefID: str=0001.0A0B0209.4D67DF33.0121,ss=1,fgs=0
Message-ID: <4D67DF33.4030105@in-telegence.net>
Date: Fri, 25 Feb 2011 17:56:19 +0100
From: Dominik Klein <dk@in-telegence.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
References: <20110224151701.GQ7840@htj.dyndns.org> <4D67591F.10105@in-telegence.net> <20110225112936.GH24828@htj.dyndns.org> <4D679688.7020503@in-telegence.net> <20110225131850.GI24828@htj.dyndns.org> <20110225145708.GB2994@redhat.com> <20110225150329.GM24828@htj.dyndns.org> <20110225151113.GD2994@redhat.com> <20110225160353.GF2994@redhat.com> <20110225160903.GR24828@htj.dyndns.org> <20110225163002.GH2994@redhat.com>
In-Reply-To: <20110225163002.GH2994@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is the new patch.
> 
> Dominik, can you please try it and see if fixes the issue.

It does.

Have a nice weekend,
Dominik
