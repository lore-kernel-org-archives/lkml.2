Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab1CNGE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 02:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab1CNGE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 02:04:26 -0400
Message-ID: <4D7DAFD9.8070705@redhat.com>
Date: Mon, 14 Mar 2011 14:04:09 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Jay Vosburgh <fubar@us.ibm.com>, netdev@vger.kernel.org
Subject: Re: [Patch V2] bonding: fix netpoll in active-backup mode
References: <1299578336-5888-1-git-send-email-amwang@redhat.com> <20110308212405.GX11864@gospo.rdu.redhat.com> <4D7773E3.5050708@redhat.com> <20110311143557.GY11864@gospo.rdu.redhat.com>
In-Reply-To: <20110311143557.GY11864@gospo.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月11日 22:35, Andy Gospodarek 写道:
>
> I'm happy to submit the patch if it works in your environment.
>
> I do not think anyone likes un-tested patches.
>

Just test it by hands, it works, you can add

Tested-by: WANG Cong <amwang@redhat.com>

Thanks!
