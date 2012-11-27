Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2K0NmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:42:17 -0500
Received: from mga12.intel.com ([143.182.124.36]:22653 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228Ab2K0NmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:42:15 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1353621075.git.dmitry.kasatkin@intel.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
Date: Tue, 27 Nov 2012 15:42:13 +0200
Message-ID: <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Any thoughts about this proposal?

- Dmitry

On Thu, Nov 22, 2012 at 11:54 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> Hello,
>
> Here is two patches for policy search speedup.
>
> First patch adds additional features flags to superblock.
> Second - implementation for IMA.
>
> Two months ago I was asking about it on mailing lists.
> Suggestion was not to use s_flags, but e.g. s_feature_flags.
>
> Any objections about such approach?
>
> Thanks,
> Dmitry
>
> Dmitry Kasatkin (2):
>   vfs: new super block feature flags attribute
>   ima: skip policy search for never appraised or measured files
>
>  include/linux/fs.h                  |    4 ++++
>  security/integrity/ima/ima_api.c    |    8 ++------
>  security/integrity/ima/ima_policy.c |   20 +++++++++++++++++---
>  security/integrity/integrity.h      |    3 +++
>  4 files changed, 26 insertions(+), 9 deletions(-)
>
> --
> 1.7.10.4
>
