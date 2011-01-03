Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1ACUjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:39:08 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33017 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab1ACUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:39:07 -0500
Message-ID: <4D2233DA.1070801@parallels.com>
Date: Mon, 3 Jan 2011 14:38:50 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kas@openvz.org>
CC: Rob Landley <rob@landley.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, <linux-nfs@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/12] make rpc_pipefs be mountable multiple time
References: <1293628470-28386-1-git-send-email-kas@openvz.org> <AANLkTi=AXz21wDeE1vPVD-6cEtj6faXN9x09eHDCsTkB@mail.gmail.com> <20101230085139.GA29697@shutemov.name> <4D1C4C7C.6050606@parallels.com> <20101230094433.GB29697@shutemov.name> <4D1C5953.6020200@parallels.com> <20101230104416.GA31824@shutemov.name> <AANLkTim2QrkSW0HufD5wp=-8ikwydN5SUS+fdWK6JHqb@mail.gmail.com> <20101230114514.GA31976@shutemov.name> <4D1C809B.30405@parallels.com> <20101231130329.GA3610@shutemov.name>
In-Reply-To: <20101231130329.GA3610@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2010 07:03 AM, Kirill A. Shutemov wrote:

> EXPORT_SYMBOL_GPL(get_rpc_pipefs);
>
> Something like this? Patch to replace patch #10 attached.

Looks good to me.  Thanks.

acked-by: Rob Landley <rlandley@parallels.com>

Rob


