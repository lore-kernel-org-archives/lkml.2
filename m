Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1C3PXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:23:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:62636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab1C3PXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:23:11 -0400
Message-Id: <b9dded$ig98p1@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,269,1299484800"; 
   d="scan'208";a="621060897"
Date: Wed, 30 Mar 2011 16:22:53 +0100
To: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
Cc: Dave Airlie <airlied@gmail.com>, r6144 <rainy6144@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1301310995.5615.92.camel@wangqingchuan> <1301336010.2217.20.camel@workstation> <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com> <1301409864.5615.98.camel@wangqingchuan> <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com> <1301421664.2151.12.camel@Portable-Work> <AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com> <20110329202608.GA3454@viiv.ffwll.ch> <AANLkTim2AyGPrun8MNq0=TyXpJ+b8i=eyHhLz01F+f2P@mail.gmail.com> <AANLkTi=vFwoKCOsvyGBQA9w01QX_TwGu_GF6mA0grr2o@mail.gmail.com> <849307$c7qtj5@azsmga001.ch.intel.com> <AANLkTinxVznFtHwM2RM3kNm9-eSXuz9L7TgfaMpgu=uZ@mail.gmail.com> <b7da2f$qtmdi3@fmsmga001.fm.intel.com> <AANLkTinHM=Kte3FbVNzMOMqNsQG_gE9WvB4tbjoTNNWB@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTinHM=Kte3FbVNzMOMqNsQG_gE9WvB4tbjoTNNWB@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 11:07:08 -0400, Jerome Glisse <j.glisse@gmail.com> wrote:
> What kind of usage didn't played well with synchronous upload/download ? X, GL ?

Performing fallback rendering for X using a shadow buffer.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
