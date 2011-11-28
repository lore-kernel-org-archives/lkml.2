Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1K1HkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:40:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab1K1HkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:40:15 -0500
Message-ID: <4ED33ABF.7000203@redhat.com>
Date: Mon, 28 Nov 2011 15:39:43 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dean Nelson <dnelson@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>, Jiri Pirko <jpirko@redhat.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 21/62] net: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-22-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-22-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月27日 13:27, Cong Wang 写道:
> Signed-off-by: Cong Wang<amwang@redhat.com>
...
>   create mode 100644 drivers/net/team/Module.symvers

This piece is not correct, I will send an updated patch.
