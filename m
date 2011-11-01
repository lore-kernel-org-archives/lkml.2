Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1KAKrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:47:40 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:60136 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753057Ab1KAKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:47:38 -0400
Message-ID: <4EAFCE44.2050102@tao.ma>
Date: Tue, 01 Nov 2011 18:47:32 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
References: <20111101191602.bb64237e8ab87671d3964ca9@canb.auug.org.au>
In-Reply-To: <20111101191602.bb64237e8ab87671d3964ca9@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,
	Thanks for the merge.
On 11/01/2011 04:16 PM, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> fs/direct-io.c between commit eb28be2b4c0a ("direct-io: separate fields
> only used in the submission path from struct dio") from Linus' tree and
> commit "fs/direct-io.c: salcuate fs_count correctly in get_more_blocks()"
> from the akpm tree.
Actually I have another patch which is rebased to current linus' tree.

So Andrew, would you mind replace the old one with the patch named
"[PATCH for 3.2] fs/direct-io.c: Calculate fs_count correctly in
get_more_blocks."

Thanks
Tao
