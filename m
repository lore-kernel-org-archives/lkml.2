Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AZSEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:04:16 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1AZSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:04:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="72073812"
From: David Brown <davidb@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated workqueues
In-Reply-To: <20110126104155.GH12520@htj.dyndns.org> (Tejun Heo's message of
	"Wed, 26 Jan 2011 11:41:55 +0100")
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-21-git-send-email-tj@kernel.org>
	<8yaoc74d0xw.fsf@huya.qualcomm.com>
	<20110126104155.GH12520@htj.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110126:tj@kernel.org::Yz7OqtCs5KAJBozc:00000X7y
X-Hashcash: 1:20:110126:stf_xl@wp.pl::GtkIicQgnXbobILc:000000eVd
X-Hashcash: 1:20:110126:linux-arm-msm@vger.kernel.org::D969KW1h6/6Kwwzo:000000000000000000000000000000000Hc9
X-Hashcash: 1:20:110126:linux-usb@vger.kernel.org::U+cNtdeQC/ImjlFq:0000000000000000000000000000000000004n9Z
X-Hashcash: 1:20:110126:linux-kernel@vger.kernel.org::RzRmGq+Ot7drI20O:0000000000000000000000000000000005Xth
Date: Wed, 26 Jan 2011 10:04:13 -0800
Message-ID: <8yaoc73a6ea.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26 2011, Tejun Heo wrote:

> On Tue, Jan 25, 2011 at 03:21:31PM -0800, David Brown wrote:

> I suppose it will show up in linux-next?  I'm planning on marking
> flush_scheduled_work() deprecated there soonish, so...

Hmm, it should be there.  Well, it will at least be there when the next
linux-next tree comes out.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
