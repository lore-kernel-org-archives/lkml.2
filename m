Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2JPPhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:37:50 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37087 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2JPPhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <157393863283F442885425D2C45428562A50158C@nasanexd02f.na.qualcomm.com>
References: <1349400892-25315-1-git-send-email-xiong@qca.qualcomm.com>
 <CAB=NE6VotAu-cugsn4==3TPX0OGPEFtdn1J+5+Rd_YfLcg9YDQ@mail.gmail.com> <157393863283F442885425D2C45428562A50158C@nasanexd02f.na.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 16 Oct 2012 08:37:26 -0700
X-Google-Sender-Auth: iaHVTRpHrhekTtgiLrpLusiUvzo
Message-ID: <CAB=NE6UoJBuLboW0=CVc5o3yj_SZOKehCc8QWP5e+zfEJBF2ug@mail.gmail.com>
Subject: Re: [PATCH] compat-drivers: update ethernet driver alx in crap dir
To: "Huang, Xiong" <xiong@qca.qualcomm.com>
Cc: "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        nic-devel <nic-devel@qualcomm.com>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        qca_vkondrat <qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 6:24 PM, Huang, Xiong <xiong@qca.qualcomm.com> wrote:
> Hi Luis
>
>     I'm refining the code, I try my best to make it upstream ASAP. Thanks !

Ok great thanks, in that case I'm going to make it policy moving
forward to simply not take in full drivers at all into compat-drivers
regardless of the situation. If  a driver is desired to be made
available, whatever the situation may be, it must now go upstream
directly onto drivers/staging or drivers/ proper somewhere.

Xiong, Vlad, I'm going to then nuke the current drivers there from the
v3.7-rc1 release, if you want those drivers to be part of the
compat-drivers-3.7 releases you will have to submit your driver
upstream into proper or staging.

The additional patches then will be for components already upstream.

  Luis
